//
//  UserDefaults+.swift
//  RxScreenProtectKit
//
//  Created by AKIO on 2019/07/03.
//  Copyright © 2019 AKIO. All rights reserved.
//

import QuartzCore
import Foundation

extension UserDefaults {
    enum DefaultType: String {
        case filter = "com.akkeylab.minificationFilter"
        case scale = "com.akkeylab.rasterizationScale"
    }
    
    func register(defaults registrationDictionary: [DefaultType: Any]) {
        var dictionary: [String: Any] = [:]
        registrationDictionary.forEach { value in
            dictionary[value.key.rawValue] = value.value
        }
        self.register(defaults: dictionary)
    }
    
    func cgFloat(forKey defaultType: DefaultType) -> CGFloat {
        return CGFloat(self.float(forKey: defaultType.rawValue))
    }
    
    func set(_ value: Float, forKey defaultType: DefaultType) {
        self.set(value, forKey: defaultType.rawValue)
    }
    
    func set(_ value: Int, forKey defaultType: DefaultType) {
        self.set(value, forKey: defaultType.rawValue)
    }
}

extension UserDefaults {
    func filterType(forKey defaultType: DefaultType) -> CALayerContentsFilter {
        let typeNum = self.integer(forKey: defaultType.rawValue)
        return FilterType(rawValue: typeNum)?.convert() ?? .trilinear
    }
}
