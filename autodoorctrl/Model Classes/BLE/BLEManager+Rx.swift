//
//  BLEManager+Rx.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 11/5/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreBluetooth

extension BLEManager: HasDelegate {
    public typealias Delegate = BLEManagerDelegate
}

class RxBLEManagerDelegateProxy:
    DelegateProxy<BLEManager, BLEManagerDelegate>,
    DelegateProxyType,
    BLEManagerDelegate
{
    public weak private(set) var bleManager: BLEManager?
    
    public init(bleManager: ParentObject) {
        self.bleManager = bleManager
        super.init(parentObject: bleManager, delegateProxy: RxBLEManagerDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        register { RxBLEManagerDelegateProxy(bleManager: $0) }
    }
}

extension Reactive where Base: BLEManager {
    private var delegate: DelegateProxy<BLEManager, BLEManagerDelegate> {
        return RxBLEManagerDelegateProxy.proxy(for: base)
    }
    
    var didConnectToPeripheral: Observable<Void> {
        return delegate
            .methodInvoked(#selector(BLEManagerDelegate.readyToSendData))
            .map { _ in () }
    }
    
    var didDisconnectFromPeripheral: Observable<Void> {
        return delegate
            .methodInvoked(#selector(BLEManagerDelegate.didDisconnectFromPeripheral))
            .map { _ in () }
    }
    
    var didReceiveString: Observable<String> {
        return delegate
            .methodInvoked(#selector(BLEManagerDelegate.didReceiveMessage(message:)))
            .map { $0[0] as! String }
    }
    
    var didReceiveError: Observable<Error?> {
        return delegate
            .methodInvoked(#selector(BLEManagerDelegate.didReceiveError(error:)))
            .map { $0[0] as? Error }
    }
    
    func connect(peripheral: CBPeripheral) -> Observable<Void> {
        base.connect(peripheral: peripheral)
        return didConnectToPeripheral
    }
    
    func readRSSI() -> Observable<BLESignalStrength> {
        base.readSignalStrength()
        return delegate
            .methodInvoked(#selector(BLEManagerDelegate.didReceiveRSSIReading(reading:)))
            .map { $0[0] as! BLESignalStrength }
    }
}
