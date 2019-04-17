//
//  CALayer+Rx.swift
//  RxScreenProtectKit
//
//  Created by AKIO on 2019/04/16.
//  Copyright © 2019 AKIO. All rights reserved.
//

import QuartzCore
import RxCocoa
import RxSwift

public extension Reactive where Base: CALayer {
    func attachMosaic(_ isMosaic: Bool) {
        base.minificationFilter = isMosaic ? .trilinear : .linear
        base.rasterizationScale = isMosaic ? 0.1 : 1.0
        base.shouldRasterize = isMosaic
    }

    var isMosaic: Binder<Bool> {
        return Binder(self.base) { (layer, mosaic: Bool) in
            layer.rx.attachMosaic(mosaic)
        }
    }
}
