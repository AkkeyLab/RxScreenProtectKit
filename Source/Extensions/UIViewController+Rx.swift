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
        return Observable.of(
            base.rx.viewWillAppear,
            NotificationCenter.default.rx.updateTrigger
            )
            .merge()
            .map { _ in UIScreen.main.isCaptured }
    }
}
