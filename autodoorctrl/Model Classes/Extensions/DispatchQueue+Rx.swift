//
//  DispatchQueue+Rx.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 11/8/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation
import RxSwift

extension Reactive where Base: DispatchQueue {
    /// Delay by the provided number of seconds on the specified queue.
    /// - Parameter seconds: number of seconds to delay
    func delayed(by seconds: Int) -> Observable<Void> {
        return Observable.create { observable in
            self.base.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(seconds)) {
                observable.onNext(())
            }
            return Disposables.create()
        }
    }
    
    func delayed(by seconds: Double) -> Observable<Void> {
        return Observable.create { observable in
            self.base.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(seconds * 1000))) {
                observable.onNext(())
            }
            return Disposables.create()
        }
    }
}
