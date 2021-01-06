//
//  SPImageView.swift
//  RxScreenProtectKit
//
//  Created by AKIO on 2019/09/10.
//  Copyright © 2019 AKIO. All rights reserved.
//

import RxSwift
import UIKit

public final class SPImageView: UIImageView {
    private var load = PublishSubject<Void>()

    override public var image: UIImage? {
        get {
            return super.image
        }
        set {
            super.image = newValue
            if newValue != nil {
                load.onNext(())
            }
        }
    }

    override public var frame: CGRect {
        get {
            return super.frame
        }
        set {
            super.frame = newValue
            load.onNext(())
        }
    }

    override public var bounds: CGRect {
        get {
            return super.bounds
        }
        set {
            super.bounds = newValue
            load.onNext(())
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
            .take(until: self.rx.deallocated)
            .bind(to: self.layer.rx.isMosaic)
        return {}
    }()
}
