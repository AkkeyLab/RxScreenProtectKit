//
//  UIViewController+Rx.swift
//  RxScreenProtectKit
//
//  Created by AKIO on 2019/07/08.
//  Copyright © 2019 AKIO. All rights reserved.
//

import RxSwift
import UIKit

extension Reactive where Base: UIViewController {
    var viewWillAppear: Observable<Void> {
        return sentMessage(#selector(base.viewWillAppear(_:)))
            .map { _ in () }
            .share(replay: 1, scope: .forever)
    }

    /// A value that indicates whether the contents of the screen are being cloned to another destination.
    public var isScreenRecord: Observable<Bool> {
        return Observable
            .of(updateTrigger, NotificationCenter.default.rx.updateTrigger)
            .merge()
            .withLatestFrom(ScreenProtectKit.shared.isValidState)
            .map { isValid in
                return isValid ? UIScreen.main.isCaptured : false
            }
            .share(replay: 1, scope: .forever)
    }

    private var updateTrigger: Observable<Void> {
        return Observable.of(
            base.rx.viewWillAppear
                .withLatestFrom(ScreenProtectKit.shared.isValidState)
                .filter { $0 }
                .map { _ in () },
            ScreenProtectKit.shared.isValidState
                .map { _ in () }
            )
            .merge()
    }
}
