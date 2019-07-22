//
//  RxBlocking+.swift
//  RxScreenProtectKitTests
//
//  Created by AKIO on 2019/07/22.
//  Copyright © 2019 AKIO. All rights reserved.
//

import RxBlocking
import RxSwift

extension ObservableType {
    func blockingSingle() throws -> Self.Element {
        do {
            return try self.take(1).toBlocking(timeout: 1).single()
        } catch {
            throw error
        }
    }
}
