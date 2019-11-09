//
//  OpeningDoorsViewController.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 11/6/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import RxSwift

/// REACTIVE PROGRAMMING FTW!
class OpeningDoorsViewController: UIViewController {
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    let door: Door
    let bag = DisposeBag()
    var didDismiss: (() -> Void)?
    
    // MARK: - Animations & Handlers
    
    lazy var hexagons: LottieSubtitledView = {
        let hexagons = LottieSubtitledView(frame: visualEffectView.bounds, animationName: "Hexagons")
        hexagons.subtitleName = "Opening Door"
        return hexagons
    }()
    
    lazy var doorOpened: LottieSubtitledView = {
        let doors = LottieSubtitledView(frame: visualEffectView.bounds, animationName: "OpenDoor")
        doors.subtitleName = "Door Opened"
        doors.loop = false
        return doors
    }()
    
    lazy var errorHandler: (Error?) -> Void = { [weak self] error in
        BLEManager.current.disconnect()
        self?.didDismiss?()
        self?.dismiss(animated: true, completion: {
            error?.showErrorMessage()
        })
    }
    
    // MARK: - Lifecycle & Init
    
    init(door: Door) {
        self.door = door
        super.init(nibName: "OpeningDoorsViewController", bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visualEffectView.contentView.addSubview(hexagons)
        visualEffectView.addRoundedCorner(cornerRadius: 20)
        setUpRx()
        BLEManager.current.connect(peripheral: door.peripheral!)
    }
    
    // MARK: - RX
    
    func setUpRx() {
        let stringAfterOpenDoor = Observable
            .zip(BLEManager.current.rx.didConnectToPeripheral, DoorsAPI.rx.openDoor(door))
            .flatMap { arg -> Observable<String> in
                BLEManager.current.send(string: arg.1.totp)
                return BLEManager.current.rx.didReceiveString
            }
            .catchError { err -> Observable<String> in
                // should not show error too fast - hence the delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    err.showErrorMessage()
                }
                return Observable.just("Failed to Receive String")
            }

        // successfully opened door - replace animations
        stringAfterOpenDoor
            .filter { $0.trimmingCharacters(in: .whitespacesAndNewlines) == "CLOSED" }
            .flatMap { [weak self] _ -> Observable<Void> in
                self?.hexagons.removeFromSuperview()
                if let doorOpenedAnimation = self?.doorOpened {
                    self?.visualEffectView.contentView.addSubview(doorOpenedAnimation)
                }
                return DispatchQueue.main.rx.delayed(by: 3)
            }
            .subscribe(onNext: { [weak self] _ in
                BLEManager.current.disconnect()
                self?.didDismiss?()
                self?.dismiss(animated: true)
            })
            .disposed(by: bag)
        
        // failed to fetch totp or connect to door - error out
        stringAfterOpenDoor
            .filter { $0 == "Failed to Receive String" }
            .subscribe(onNext: { [weak self] _ in
                self?.errorHandler(nil)
            })
            .disposed(by: bag)
        
        BLEManager.current.rx.didReceiveError
            .subscribe(onNext: { [weak self] error in
                self?.errorHandler(error)
            })
            .disposed(by: bag)
    }
}
