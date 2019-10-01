//
//  Setting.swift
//  AppNews
//
//  Created by Максим Лисица on 01/10/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import Foundation

class Settings {
    
    var isDetail: Bool {
        get {
            return UserDefaults.standard.value(forKey: "withDetail") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "withDetail")
        }
    }
    var isTimer: Bool {
        get {
            return UserDefaults.standard.value(forKey: "withTimer") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "withTimer")
        }
    }
    var valueTimer: Int {
        get {
            return UserDefaults.standard.value(forKey: "valueTimer") as? Int ?? 10
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "valueTimer")
        }
    }
}
