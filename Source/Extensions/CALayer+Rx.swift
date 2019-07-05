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
    var isValid: Bool
    /// The filter used when reducing the size of the content.
    var filter: CALayerContentsFilter
    /// The scale at which to rasterize content, relative to the coordinate space of the layer.
    var scale: CGFloat

    init (isValid: Bool, filter: CALayerContentsFilter = .trilinear, scale: CGFloat = 0.1) {
        self.isValid = isValid
        self.filter = filter
        self.scale = scale
    }

    var minificationFilter: CALayerContentsFilter {
        return isValid ? filter : .linear
    }

    var rasterizationScale: CGFloat {
        return isValid ? scale : 1.0
    }
}

extension CALayer {
    func attachMosaic(type: MosaicType) {
        minificationFilter = type.minificationFilter
        rasterizationScale = type.rasterizationScale
        shouldRasterize = type.isValid
    }
}

public extension CALayer {
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
