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
    public var viewWillAppear: Observable<Void> {
        return sentMessage(#selector(base.viewWillAppear(_:)))
            .map { _ in () }
            .share(replay: 1, scope: .forever)
    }
}
