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
            if newValue != nil {
                load.onNext(())
            }
        }
        get {
            return super.image
        }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    private lazy var setup: (() -> Void) = {
        _ = Observable.of(
            self.rx.isScreenRecord.map { _ in () },
            load
            )
            .merge()
            .withLatestFrom(self.rx.isScreenRecord)
            .takeUntil(self.rx.deallocated)
            .bind(to: self.layer.rx.isMosaic)
        return {}
    }()
}
