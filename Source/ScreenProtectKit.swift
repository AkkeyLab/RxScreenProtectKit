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
    /// It conforms to CALayerContentsFilter.
    public enum FilterType: Int {
        /// Nearest neighbor interpolation filter.
        case nearest
        /// Linear interpolation filter.
        case linear
        /// Trilinear minification filter. Enables mipmap generation.
        case trilinear

        internal func convert() -> CALayerContentsFilter {
            switch self {
            case .nearest:
                return .nearest
            case .linear:
                return .linear
            case .trilinear:
                return .trilinear
            }
        }
    }

    /**
     Set up various parameters.
     
     # FilterType
     
     It conforms to CALayerContentsFilter.
        - nearest
        - linear
        - trilinear
     
     - parameters:
        - filter: The filter used when reducing the size of the content.
        - scale: The scale at which to rasterize content, relative to the coordinate space of the layer.
    */
    public static func config(filter: FilterType = .trilinear, scale: Float = 0.1) {
        UserDefaults.standard.apply { this in
            this.set(filter.rawValue, forKey: .filter)
            this.set(scale, forKey: .scale)
        }
    }
}
