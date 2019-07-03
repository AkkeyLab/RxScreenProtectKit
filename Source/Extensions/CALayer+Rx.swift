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

public struct MosaicType {
    public var isValid: Bool
    /// The filter used when reducing the size of the content.
    public var filter: CALayerContentsFilter
    /// The scale at which to rasterize content, relative to the coordinate space of the layer.
    public var scale: CGFloat

    public init (isValid: Bool, filter: CALayerContentsFilter = .trilinear, scale: CGFloat = 0.1) {
        self.isValid = isValid
        self.filter = filter
        self.scale = scale
    }


    internal var minificationFilter: CALayerContentsFilter {
        return isValid ? filter : .linear
    }

    internal var rasterizationScale: CGFloat {
        return isValid ? scale : 1.0
    }
}

public extension CALayer {
    internal func attachMosaic(type: MosaicType) {
        minificationFilter = type.minificationFilter
        rasterizationScale = type.rasterizationScale
        shouldRasterize = type.isValid
    }

    var mosaicType: MosaicType {
        set {
            attachMosaic(type: newValue)
        }
        get {
            return .init(isValid: shouldRasterize)
        }
    }
}

public extension Reactive where Base: CALayer {
    var isMosaic: Binder<Bool> {
        return Binder(self.base) { layer, isValid in
            UserDefaults.standard.apply { this in
                // Set default value for UserDefaults
                this.register(defaults: [.filter: 0, .scale: 0.1])
                layer.attachMosaic(type: .init(isValid: isValid,
                                               filter: this.filterType(forKey: .filter),
                                               scale: this.cgFloat(forKey: .scale)))
            }
        }
    }
}
