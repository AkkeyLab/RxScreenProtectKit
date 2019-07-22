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

struct MosaicType {
    /// This flag indicates the presence or absence of a mosaic.
    var isValid: Bool
    /// The scale at which to rasterize content, relative to the coordinate space of the layer.
    var rasterizationScale: CGFloat
    /// The filter used when reducing the size of the content.
    var minificationFilter: CALayerContentsFilter
    /// The filter used when increasing the size of the content.
    var magnificationFilter: CALayerContentsFilter

    /**
     This type indicates a mosaic.
     
     - parameters:
        - isValid: This flag indicates the presence or absence of a mosaic.
        - rasterizationScale: The scale at which to rasterize content, relative to the coordinate space of the layer.
        - minificationFilter: The filter used when reducing the size of the content.
        - magnificationFilter: The filter used when increasing the size of the content.
     */
    init (isValid: Bool,
          rasterizationScale: CGFloat = 0.1,
          minificationFilter: CALayerContentsFilter = .trilinear,
          magnificationFilter: CALayerContentsFilter = .nearest) {
        self.isValid = isValid
        self.rasterizationScale = rasterizationScale
        self.minificationFilter = minificationFilter
        self.magnificationFilter = magnificationFilter
    }
}

extension CALayer {
    /**
     attach the mosaic.

     - parameters:
        - type: This type indicates a mosaic.
     */
    func attachMosaic(type: MosaicType) {
        shouldRasterize = type.isValid
        rasterizationScale = type.isValid ? type.rasterizationScale : 1.0
        minificationFilter = type.isValid ? type.minificationFilter : .linear
        magnificationFilter = type.isValid ? type.magnificationFilter : .linear
    }
}

public extension CALayer {
    /// Reflects the parameter change.
    /// Use in a production environment is deprecated.
    func applyMosaic(kit: ScreenProtectKit = .shared) {
        attachMosaic(type: .init(isValid: shouldRasterize,
                                 rasterizationScale: kit.rasterizationScale,
                                 minificationFilter: kit.minificationFilter,
                                 magnificationFilter: kit.magnificationFilter)
        )
    }
}

public extension Reactive where Base: CALayer {
    /// Bindable sink for Mosaic.
    var isMosaic: Binder<Bool> {
        return Binder(self.base) { layer, isValid in
            let kit = ScreenProtectKit.shared
            layer.attachMosaic(type: .init(isValid: isValid,
                                           rasterizationScale: kit.rasterizationScale,
                                           minificationFilter: kit.minificationFilter,
                                           magnificationFilter: kit.magnificationFilter)
            )
        }
    }
}
