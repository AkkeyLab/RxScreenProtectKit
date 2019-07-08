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

    internal var filter: CALayerContentsFilter = .trilinear
    internal var scale: CGFloat = 0.1

    private init() {}

    /**
     Set up various parameters.

     - parameters:
        - filter: The filter used when reducing the size of the content.
        - scale: The scale at which to rasterize content, relative to the coordinate space of the layer.
    */
    public func config(filter: CALayerContentsFilter = .trilinear, scale: CGFloat = 0.1) {
        self.filter = filter
        self.scale = scale
    }
}
