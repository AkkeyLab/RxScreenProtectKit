//
//  SPImageView.swift
//  RxScreenProtectKit
//
//  Created by AKIO on 2019/09/10.
//  Copyright © 2019 AKIO. All rights reserved.
//

import RxSwift
import UIKit

public class SPImageView: UIImageView {
    private var load = PublishSubject<Void>()

    override public var image: UIImage? {
        set {
            super.image = newValue
            setup()
            if newValue != nil {
                load.onNext(())
            }
        }
        get {
            return super.image
        }
    }

    private lazy var setup: (() -> Void) = {
        _ = load
            .delay(.milliseconds(100), scheduler: MainScheduler.instance)
            .withLatestFrom(self.rx.isScreenRecord)
            .map { !$0 }
            .takeUntil(self.rx.deallocated)
            .bind(to: self.layer.rx.isMosaic)
        return {}
    }()
}
