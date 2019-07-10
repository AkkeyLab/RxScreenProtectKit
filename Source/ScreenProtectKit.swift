//
//  ScreenProtectKit.swift
//  RxScreenProtectKit
//
//  Created by AKIO on 2019/07/03.
//  Copyright © 2019 AKIO. All rights reserved.
//

import QuartzCore
import Foundation

public final class ScreenProtectKit {
    public static let shared = ScreenProtectKit()

    internal var rasterizationScale: CGFloat = 0.1
    internal var minificationFilter: CALayerContentsFilter = .trilinear
    internal var magnificationFilter: CALayerContentsFilter = .nearest

    private init() {}

    /**
     Set up various parameters.

     - parameters:
        - rasterizationScale: The scale at which to rasterize content, relative to the coordinate space of the layer.
        - minificationFilter: The filter used when reducing the size of the content.
        - magnificationFilter: The filter used when increasing the size of the content.
    */
    public func config(rasterizationScale: CGFloat = 0.1,
                       minificationFilter: CALayerContentsFilter = .trilinear,
                       magnificationFilter: CALayerContentsFilter = .nearest) {
        self.rasterizationScale = rasterizationScale
        self.minificationFilter = minificationFilter
        self.magnificationFilter = magnificationFilter
    }
}
