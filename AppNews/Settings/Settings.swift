//
//  Setting.swift
//  AppNews
//
//  Created by Максим Лисица on 01/10/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import Foundation

/// Настройки
class Settings {
    
    /// Переменная, которая определяет использовать ли расширенный режим при отображении новости или нет
    var isDetail: Bool {
        get {
            return UserDefaults.standard.value(forKey: "withDetail") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "withDetail")
        }
    }
    /// Переменная определяет использовать ли таймер для автоматического обновления новостей
    var isTimer: Bool {
        get {
            return UserDefaults.standard.value(forKey: "withTimer") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "withTimer")
        }
    }
    /// Переменная определяет через какое время обновлять данные есть таймер включен
    var valueTimer: Int {
        get {
            return UserDefaults.standard.value(forKey: "valueTimer") as? Int ?? arrayValueTimer[0]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "valueTimer")
        }
    }
    /// Массив с временем для выбора обновления контента
    let arrayValueTimer = [10, 20, 30, 50, 70]
}
