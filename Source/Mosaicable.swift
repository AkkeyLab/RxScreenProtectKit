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

public extension Mosaicable where Self: UIViewController {
    /// A value that indicates whether the contents of the screen are being cloned to another destination.
    var isScreenRecord: Observable<Bool> {
        return Observable.of(
            self.rx.viewWillAppear,
            NotificationCenter.default.rx
                .notification2(UIScreen.capturedDidChangeNotification),
            NotificationCenter.default.rx
                .notification2(UIApplication.willEnterForegroundNotification),
            NotificationCenter.default.rx
                .notification2(UIApplication.didEnterBackgroundNotification)
        )
            .merge()
            .map { _ in UIScreen.main.isCaptured }
    }
}

private extension Reactive where Base: NotificationCenter {
    func notification2(_ name: Notification.Name?) -> RxSwift.Observable<Void> {
        return self.notification(name).map { _ in () }
    }
}
