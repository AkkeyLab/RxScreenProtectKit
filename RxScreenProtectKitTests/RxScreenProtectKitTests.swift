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

    func testValidMosaicType() {
        let type = MosaicType(isValid: true)
        XCTAssertEqual(type.minificationFilter, .trilinear)
        XCTAssertEqual(type.rasterizationScale, 0.1)
    }

    func testInvalidMosaicType() {
        let type = MosaicType(isValid: false)
        XCTAssertEqual(type.minificationFilter, .linear)
        XCTAssertEqual(type.rasterizationScale, 1.0)
    }

    func testAttachMosaic() {
        let layer = CALayer()
        layer.attachMosaic(type: MosaicType(isValid: true))
        XCTAssertEqual(layer.minificationFilter, .trilinear)
        XCTAssertEqual(layer.rasterizationScale, 0.1)
        XCTAssertEqual(layer.shouldRasterize, true)
    }
}
