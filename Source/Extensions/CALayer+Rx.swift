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
    /// Bindable sink for Mosaic.
    var isMosaic: Binder<Bool> {
        return Binder(self.base) { layer, isValid in
            let kit = ScreenProtectKit.shared
            layer.attachMosaic(type: .init(isValid: isValid,
                                           rasterizationScale: kit.rasterizationScale,
                                           pixelBoxSize: kit.pixelBoxSize,
                                           minificationFilter: kit.minificationFilter,
                                           magnificationFilter: kit.magnificationFilter)
            )
        }
    }
}
