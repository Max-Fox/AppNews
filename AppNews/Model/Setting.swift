//
//  Setting.swift
//  AppNews
//
//  Created by Максим Лисица on 01/10/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import Foundation

class Setting {
    
    var isDetail: Bool?
    var isTimer: Bool?
    var valueTimer: Int?
    
    init() {
        self.isDetail = getIsDetail()
        self.isTimer = getIsTimer()
        self.valueTimer = getValueTimer()
    }
    
    func getIsTimer() -> Bool {
        let isTimer = UserDefaults.standard.value(forKey: "withTimer") as? Bool ?? false
        return isTimer
    }
    
    func getValueTimer() -> Int {
        let valueTimer = UserDefaults.standard.value(forKey: "valueTimer") as? Int ?? 0
        return valueTimer
    }
    
    func getIsDetail() -> Bool {
        let isDetail = UserDefaults.standard.value(forKey: "withDetail") as? Bool ?? false
        return isDetail
    }
    
    func setIsTimer(with isOn: Bool) {
        UserDefaults.standard.set(isOn, forKey: "withTimer")
    }
    
    func setValueTimer(with value: Int) {
        UserDefaults.standard.set(value, forKey: "valueTimer")
    }
    
    func setIsDetail(with value: Bool) {
        UserDefaults.standard.set(value, forKey: "withDetail")
    }
}
