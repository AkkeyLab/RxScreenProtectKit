//
//  Mosaicable.swift
//  RxScreenProtectKit
//
//  Created by AKIO on 2019/04/16.
//  Copyright © 2019 AKIO. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

public protocol Mosaicable {
    var isScreenRecord: Observable<Bool> { get }
}

public extension Mosaicable {
    var isScreenRecord: Observable<Bool> {
        return NotificationCenter
            .default
            .rx
            .notification(UIScreen.capturedDidChangeNotification, object: nil)
            .map { _ in UIScreen.main.isCaptured }
    }
}
