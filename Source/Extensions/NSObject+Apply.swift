//
//  NSObject+Apply.swift
//  RxScreenProtectKit
//
//  Created by AKIO on 2019/07/03.
//  Copyright © 2019 AKIO. All rights reserved.
//

import Foundation

public protocol Appliable {}

extension Appliable {
    @discardableResult
    public func apply(closure: (_ this: Self) -> Void) -> Self {
        closure(self)
        return self
    }
}

extension NSObject: Appliable {}
