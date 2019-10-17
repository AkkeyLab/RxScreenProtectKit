//
//  ScreenProtectKit.swift
//  RxScreenProtectKit
//
//  Created by AKIO on 2019/07/03.
//  Copyright © 2019 AKIO. All rights reserved.
//

import QuartzCore
import RxCocoa
import RxSwift
import Foundation

public final class ScreenProtectKit {
    public static let shared = ScreenProtectKit()

    internal var rasterizationScale: CGFloat = 0.1
    internal var pixelBoxSize: CGFloat = 0
    internal var minificationFilter: CALayerContentsFilter = .trilinear
    internal var magnificationFilter: CALayerContentsFilter = .nearest
    internal lazy var isValidState = _isValid.distinctUntilChanged()

    private var _isValid = BehaviorRelay<Bool>(value: true)
    /**
     You can switch whether or not to subscribe to the screen recording status. Initially enabled.
     In addition, immediately after switching between disabled and enabled,
     false will flow once from `isScreenRecord` regardless of whether screen recording is performed.
    */
    public var isValid: Bool {
        set {
            _isValid.accept(newValue)
        }
        get {
            return _isValid.value
        }
    }

    private init() {}

    /**
     Set up various parameters.

     - parameters:
        - rasterizationScale: The scale at which to rasterize content, relative to the coordinate space of the layer.
        - pixelBoxSize: When compressing an image, specify the number of pixels to be compressed to one pixel.
          If this is non-zero, `rasterizationScale` will be ignored.
        - minificationFilter: The filter used when reducing the size of the content.
        - magnificationFilter: The filter used when increasing the size of the content.
    */
    public func config(rasterizationScale: CGFloat = 0.1,
                       pixelBoxSize: CGFloat = 0,
                       minificationFilter: CALayerContentsFilter = .trilinear,
                       magnificationFilter: CALayerContentsFilter = .nearest) {
        self.rasterizationScale = rasterizationScale
        self.pixelBoxSize = pixelBoxSize
        self.minificationFilter = minificationFilter
        self.magnificationFilter = magnificationFilter
    }
}
