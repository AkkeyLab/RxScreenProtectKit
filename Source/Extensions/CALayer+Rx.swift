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
    /// The filter used when reducing the size of the content.
    var filter: CALayerContentsFilter
    /// The scale at which to rasterize content, relative to the coordinate space of the layer.
    var scale: CGFloat

    /**
     This type indicates a mosaic.
     
     # FilterType (CALayerContentsFilter)
     
        - nearest
        - linear
        - trilinear
     
     - parameters:
        - isValid: This flag indicates the presence or absence of a mosaic.
        - filter: The filter used when reducing the size of the content.
        - scale: The scale at which to rasterize content, relative to the coordinate space of the layer.
     */
    init (isValid: Bool, filter: CALayerContentsFilter = .trilinear, scale: CGFloat = 0.1) {
        self.isValid = isValid
        self.filter = filter
        self.scale = scale
    }

    /// The filter used when reducing the size of the content.
    var minificationFilter: CALayerContentsFilter {
        return isValid ? filter : .linear
    }

    /// The scale at which to rasterize content, relative to the coordinate space of the layer.
    var rasterizationScale: CGFloat {
        return isValid ? scale : 1.0
    }
}

extension CALayer {
    /**
     attach the mosaic.

     - parameters:
        - type: This type indicates a mosaic.
     */
    func attachMosaic(type: MosaicType) {
        minificationFilter = type.minificationFilter
        rasterizationScale = type.rasterizationScale
        shouldRasterize = type.isValid
    }
}

public extension CALayer {
    /// Reflects the parameter change.
    func applyMosaic() {
        UserDefaults.standard.apply { this in
            let isValid = shouldRasterize
            let filter = this.filterType(forKey: .filter)
            let scale = this.cgFloat(forKey: .scale)
            attachMosaic(type: .init(isValid: isValid, filter: filter, scale: scale))
        }
    }
}

public extension Reactive where Base: CALayer {
    /// Bindable sink for Mosaic.
    var isMosaic: Binder<Bool> {
        return Binder(self.base) { _, isValid in
            UserDefaults.standard.apply { this in
                // Set default value for UserDefaults
                this.register(defaults: [.filter: 0, .scale: 0.1])
                let filter = this.filterType(forKey: .filter)
                let scale = this.cgFloat(forKey: .scale)
                self.base.attachMosaic(type: .init(isValid: isValid, filter: filter, scale: scale))
            }
        }
    }
}
