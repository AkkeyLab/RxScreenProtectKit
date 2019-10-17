//
//  CALayer+Mosaic.swift
//  RxScreenProtectKit
//
//  Created by AKIO on 2019/08/29.
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
    /// When compressing an image, specify the number of pixels to be compressed to one pixel.
    var pixelBoxSize: CGFloat
    /// The filter used when reducing the size of the content.
    var minificationFilter: CALayerContentsFilter
    /// The filter used when increasing the size of the content.
    var magnificationFilter: CALayerContentsFilter

    /**
     This type indicates a mosaic.

     - parameters:
        - isValid: This flag indicates the presence or absence of a mosaic.
        - rasterizationScale: The scale at which to rasterize content, relative to the coordinate space of the layer.
        - pixelBoxSize: When compressing an image, specify the number of pixels to be compressed to one pixel.
          If this is non-zero, `rasterizationScale` will be ignored.
        - minificationFilter: The filter used when reducing the size of the content.
        - magnificationFilter: The filter used when increasing the size of the content.
     */
    init (isValid: Bool,
          rasterizationScale: CGFloat,
          pixelBoxSize: CGFloat,
          minificationFilter: CALayerContentsFilter = .trilinear,
          magnificationFilter: CALayerContentsFilter = .nearest) {
        self.isValid = isValid
        self.rasterizationScale = rasterizationScale
        self.pixelBoxSize = pixelBoxSize
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
        let absoluteScale = (2 * type.pixelBoxSize) / (bounds.height + bounds.width)
        if absoluteScale == 0 {
            rasterizationScale = type.isValid ? type.rasterizationScale : 1.0
        } else {
            rasterizationScale = absoluteScale
        }
        shouldRasterize = type.isValid
        minificationFilter = type.isValid ? type.minificationFilter : .linear
        magnificationFilter = type.isValid ? type.magnificationFilter : .linear
    }

    /// Reflects the parameter change.
    /// Use in a production environment is deprecated.
    public func applyMosaic(kit: ScreenProtectKit = .shared) {
        attachMosaic(type: .init(isValid: shouldRasterize,
                                 rasterizationScale: kit.rasterizationScale,
                                 pixelBoxSize: kit.pixelBoxSize,
                                 minificationFilter: kit.minificationFilter,
                                 magnificationFilter: kit.magnificationFilter)
        )
    }
}
