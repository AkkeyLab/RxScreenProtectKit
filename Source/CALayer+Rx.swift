//
//  CALayer+Rx.swift
//  RxScreenProtectKit
//
//  Created by AKIO on 2019/04/16.
//  Copyright © 2019 AKIO. All rights reserved.
//

import QuartzCore
import RxCocoa

public extension CALayer {
    private func attachMosaic(_ isMosaic: Bool) {
        minificationFilter = isMosaic ? .trilinear : .linear
        rasterizationScale = isMosaic ? 0.1 : 1.0
        shouldRasterize = isMosaic
    }

    var isMosaic: Binder<Bool> {
        return Binder(self) { (layer, isMosaic: Bool) in
            layer.attachMosaic(isMosaic)
        }
    }
}
