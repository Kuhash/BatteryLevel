//
//  CommunicationExtension.swift
//  BatteryLevel
//
//  Created by Maciej Kucharski on 05/06/2017.
//  Copyright © 2017 Maciej Kucharski. All rights reserved.
//

import UIKit

extension Dictionary {
    
    enum BatteryDictionary: String {
        case lastKnownBatteryLevel = "lastKnownBatteryLevel"
        case currentBatteryLevel = "currentBatteryLevel"
        case image = "batteryImage"
    }
    
    mutating func setLastKnownBatteryLevel(value: Float) {
        setBatteryValue(enumValue: .lastKnownBatteryLevel, value: value as? Value)
    }
    
    func getLastKnownBatteryLevel() -> Float {
        let value = getBatteryValue(enumValue: .lastKnownBatteryLevel)
        if (value != nil) {
            return value as! Float
        } else {
            return 0
        }
    }
    
    mutating func setCurrentBatteryLevel(value: Float) {
        setBatteryValue(enumValue: .currentBatteryLevel, value: value as? Value)
    }
    
    func getCurrentBatteryLevel() -> Float {
        let value = getBatteryValue(enumValue: .currentBatteryLevel)
        if (value != nil) {
            return value as! Float
        } else {
            return 0
        }
    }
    
    mutating func setImages(value: [Data]) {
        setBatteryValue(enumValue: .image, value: value as? Value)
    }
    
    func getImages() -> [Data] {
        let value = getBatteryValue(enumValue: .image)
        return value as! [Data]
    }
    
    // private
    
    private mutating func setBatteryValue(enumValue: BatteryDictionary, value: Value?) {
        self[enumValue.rawValue as! Key] = value
    }
    
    private func getBatteryValue(enumValue: BatteryDictionary) -> Value? {
        return self[enumValue.rawValue as! Key]
    }
}
