//
//  RxScreenProtectKitTests.swift
//  RxScreenProtectKitTests
//
//  Created by AKIO on 2019/04/16.
//  Copyright © 2019 AKIO. All rights reserved.
//

import RxSwift
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

    func testApplyMosaic() {
        let layer = CALayer()
        layer.shouldRasterize = true
        let kit = ScreenProtectKit.shared
        kit.config(rasterizationScale: 0.5, minificationFilter: .trilinear, magnificationFilter: .trilinear)

        layer.applyMosaic(kit: kit)
        XCTAssertEqual(layer.shouldRasterize, true)
        XCTAssertEqual(layer.rasterizationScale, 0.5)
        XCTAssertEqual(layer.minificationFilter, .trilinear)
        XCTAssertEqual(layer.magnificationFilter, .trilinear)
    }

    // swiftlint:disable force_try
    func testRecodeNotificationForViewController() {
        let viewController = UIViewController()

        DispatchQueue.main.async {
            viewController.viewWillAppear(false)
        }

        let isRecord = try! viewController.rx.isScreenRecord
            .blockingSingle()
        XCTAssertEqual(isRecord, false)
    }

    func testRecodeNotificationForView() {
        let view = UIView()

        DispatchQueue.main.async {
            view.layoutSubviews()
        }

        let isRecord = try! view.rx.isScreenRecord
            .blockingSingle()
        XCTAssertEqual(isRecord, false)
    }
    // swiftlint:enable force_try
}
