//
//  OpeningDoorsViewController.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 11/6/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import RxSwift

class OpeningDoorsViewController: UIViewController {
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    let door: Door
    let bag = DisposeBag()
    var didDismiss: (() -> Void)?
    
    init(door: Door) {
        self.door = door
        super.init(nibName: "OpeningDoorsViewController", bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let hexagons = LottieSubtitledView(frame: visualEffectView.bounds, animationName: "Hexagons")
        hexagons.subtitleName = "Opening Door"
        visualEffectView.contentView.addSubview(hexagons)
        visualEffectView.addRoundedCorner(cornerRadius: 20)
        setUpRx()
        BLEManager.current.connect(peripheral: door.peripheral!)
    }
    
    func setUpRx() {
        Observable
            .zip(BLEManager.current.rx.didConnectToPeripheral, DoorsAPI.rx.openDoor(door))
            .flatMap { arg -> Observable<String> in
                BLEManager.current.send(string: arg.1.totp)
                return BLEManager.current.rx.didReceiveString
            }
            .filter { $0.trimmingCharacters(in: .whitespacesAndNewlines) == "INVALID TOKEN" }
            .subscribe(onNext: { [weak self] _ in
                BLEManager.current.disconnect()
                self?.didDismiss?()
                self?.dismiss(animated: true, completion: {
                    SwiftMessagesWrapper.showErrorMessage(title: "Error", body: "Invalid Token")
                })
            })
            .disposed(by: bag)
        
        BLEManager.current.rx.didReceiveError
            .subscribe(onNext: { [weak self] error in
                BLEManager.current.disconnect()
                self?.didDismiss?()
                self?.dismiss(animated: true, completion: {
                    error?.showErrorMessage()
                })
            })
            .disposed(by: bag)
    }
}
