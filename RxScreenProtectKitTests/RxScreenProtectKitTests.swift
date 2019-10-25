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
        let type = MosaicType(isValid: true, rasterizationScale: 0.1, pixelBoxSize: 0)
        XCTAssertEqual(type.minificationFilter, .trilinear)
        XCTAssertEqual(type.rasterizationScale, 0.1)
    }

    func testValidAttachMosaic() {
        let layer = CALayer()
        layer.attachMosaic(type: MosaicType(isValid: true, rasterizationScale: 0.1, pixelBoxSize: 0))
        XCTAssertEqual(layer.minificationFilter, .trilinear)
        XCTAssertEqual(layer.magnificationFilter, .nearest)
        XCTAssertEqual(layer.rasterizationScale, 0.1)
        XCTAssertEqual(layer.shouldRasterize, true)
    }

    func testInvalidAttachMosaic() {
        let layer = CALayer()
        layer.attachMosaic(type: MosaicType(isValid: false, rasterizationScale: 0.1, pixelBoxSize: 0))
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

    func testLoadValidFlag() {
        let kit = ScreenProtectKit.shared
        kit.isValid = false
        XCTAssertEqual(kit.isValid, false)
    }

    // swiftlint:disable force_try
    func testFlagValidRecodeNotificationForViewController() {
        let viewController = UIViewController()
        ScreenProtectKit.shared.isValid = true

        DispatchQueue.main.async {
            viewController.viewWillAppear(false)
        }

        let isRecord = try! viewController.rx.isScreenRecord
            .skip(1)
            .blockingSingle()
        XCTAssertEqual(isRecord, false)
    }

    func testFlagValidRecodeNotificationForView() {
        let view = UIView()
        ScreenProtectKit.shared.isValid = true

        DispatchQueue.main.async {
            view.layoutSubviews()
        }

        let isRecord = try! view.rx.isScreenRecord
            .skip(1)
            .blockingSingle()
        XCTAssertEqual(isRecord, false)
    }

    func testFlagInvalidRecodeNotificationForViewController() {
        let viewController = UIViewController()
        let bag = DisposeBag()
        ScreenProtectKit.shared.isValid = false

        viewController.rx.isScreenRecord
            .skip(1)
            .subscribe(onNext: { _ in
                XCTAssert(false)
            })
            .disposed(by: bag)

        viewController.viewWillAppear(false)
    }

    func testFlagInvalidRecodeNotificationForView() {
        let view = UIView()
        let bag = DisposeBag()
        ScreenProtectKit.shared.isValid = false

        _ = view.rx.isScreenRecord
            .skip(1)
            .subscribe(onNext: { _ in
                XCTAssert(false)
            })
            .disposed(by: bag)

        view.layoutSubviews()
    }

    func testFlagValidForViewController() {
        let viewController = UIViewController()
        let kit = ScreenProtectKit.shared

        kit.isValid = false // For distinctUntilChanged()
        DispatchQueue.main.async {
            kit.isValid = true
        }

        let isRecord = try! viewController.rx.isScreenRecord
            .skip(1)
            .blockingSingle()
        XCTAssertEqual(isRecord, false)
    }

    func testFlagInvalidForViewController() {
        let viewController = UIViewController()
        let kit = ScreenProtectKit.shared

        kit.isValid = true // For distinctUntilChanged()
        DispatchQueue.main.async {
            kit.isValid = false
        }

        let isRecord = try! viewController.rx.isScreenRecord
            .skip(1)
            .blockingSingle()
        XCTAssertEqual(isRecord, false)
    }

    func testFlagValidForView() {
        let view = UIView()
        let kit = ScreenProtectKit.shared

        kit.isValid = false // For distinctUntilChanged()
        DispatchQueue.main.async {
            kit.isValid = true
        }

        let isRecord = try! view.rx.isScreenRecord
            .skip(1)
            .blockingSingle()
        XCTAssertEqual(isRecord, false)
    }

    func testFlagInvalidForView() {
        let view = UIView()
        let kit = ScreenProtectKit.shared

        kit.isValid = true // For distinctUntilChanged()
        DispatchQueue.main.async {
            kit.isValid = false
        }

        let isRecord = try! view.rx.isScreenRecord
            .skip(1)
            .blockingSingle()
        XCTAssertEqual(isRecord, false)
    }

    func testSPImageView() {
        let view = SPImageView()
        view.layoutSubviews()
        XCTAssertEqual(view.image, nil)
        view.image = UIImage(named: "UserMainPhoto")
        XCTAssertEqual(view.layer.minificationFilter, .linear)
        XCTAssertEqual(view.layer.magnificationFilter, .linear)
        XCTAssertEqual(view.layer.rasterizationScale, 1.0)
        XCTAssertEqual(view.layer.shouldRasterize, false)
        XCTAssertEqual(view.image, UIImage(named: "UserMainPhoto"))
    }

    func testSPLabel() {
        let changeTextExpectation: XCTestExpectation? = self.expectation(description: "Change Text")
        let label = SPLabel()
        label.layoutSubviews()
        XCTAssertEqual(label.text, nil)
        label.text = "original"
        label.protectText = "protect"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(label.text, "original")
            changeTextExpectation?.fulfill()
        }
        self.waitForExpectations(timeout: 1, handler: nil)
    }

    func testPixelBoxSize() {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
        layer.attachMosaic(type: MosaicType(isValid: true, rasterizationScale: 0.1, pixelBoxSize: 5))
        XCTAssertEqual(layer.minificationFilter, .trilinear)
        XCTAssertEqual(layer.magnificationFilter, .nearest)
        XCTAssertEqual(layer.rasterizationScale, 0.05)
        XCTAssertEqual(layer.shouldRasterize, true)
        layer.attachMosaic(type: MosaicType(isValid: true, rasterizationScale: 0.1, pixelBoxSize: 10))
        XCTAssertEqual(layer.rasterizationScale, 0.1)
    }
    // swiftlint:enable force_try
}
