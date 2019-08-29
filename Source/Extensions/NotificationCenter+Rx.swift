//
//  NotificationCenter+Rx.swift
//  RxScreenProtectKit
//
//  Created by AKIO on 2019/08/29.
//  Copyright © 2019 AKIO. All rights reserved.
//

import RxSwift
import UIKit

extension Reactive where Base: NotificationCenter {
    var updateTrigger: Observable<Void> {
        return Observable.of(
            NotificationCenter.default.rx
                .notification(UIScreen.capturedDidChangeNotification),
            NotificationCenter.default.rx
                .notification(UIApplication.willEnterForegroundNotification),
            NotificationCenter.default.rx
                .notification(UIApplication.didEnterBackgroundNotification)
            )
            .merge()
            .withLatestFrom(ScreenProtectKit.shared.isValidState)
            .filter { $0 }
            .map { _ in () }
    }
}
