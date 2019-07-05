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
    /// A value that indicates whether the contents of the screen are being cloned to another destination.
    var isScreenRecord: Observable<Bool> {
        return Observable.of(
            NotificationCenter.default.rx
                .notification(UIScreen.capturedDidChangeNotification),
            NotificationCenter.default.rx
                .notification(UIApplication.willEnterForegroundNotification),
            NotificationCenter.default.rx
                .notification(UIApplication.didEnterBackgroundNotification)
        )
            .merge()
            .map { _ in UIScreen.main.isCaptured }
    }
}
