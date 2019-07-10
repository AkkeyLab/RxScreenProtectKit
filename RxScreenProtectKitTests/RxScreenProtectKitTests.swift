//
//  RxScreenProtectKitTests.swift
//  RxScreenProtectKitTests
//
//  Created by AKIO on 2019/04/16.
//  Copyright © 2019 AKIO. All rights reserved.
//

import XCTest
@testable import RxScreenProtectKit

final class RxScreenProtectKitTests: XCTestCase {

    func testMosaicType() {
        let type = MosaicType(isValid: true)
        XCTAssertEqual(type.minificationFilter, .trilinear)
        XCTAssertEqual(type.rasterizationScale, 0.1)
    }

    func testValidAttachMosaic() {
        let layer = CALayer()
        layer.attachMosaic(type: MosaicType(isValid: true))
        XCTAssertEqual(layer.minificationFilter, .trilinear)
        XCTAssertEqual(layer.magnificationFilter, .nearest)
        XCTAssertEqual(layer.rasterizationScale, 0.1)
        XCTAssertEqual(layer.shouldRasterize, true)
    }

    func testInvalidAttachMosaic() {
        let layer = CALayer()
        layer.attachMosaic(type: MosaicType(isValid: false))
        XCTAssertEqual(layer.minificationFilter, .linear)
        XCTAssertEqual(layer.magnificationFilter, .linear)
        XCTAssertEqual(layer.rasterizationScale, 1.0)
        XCTAssertEqual(layer.shouldRasterize, false)
    }
}
