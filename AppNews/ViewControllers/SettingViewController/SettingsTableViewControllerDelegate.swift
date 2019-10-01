//
//  SettingsProtocol.swift
//  AppNews
//
//  Created by Максим Лисица on 27/09/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import UIKit

/// Протокол для настроек
protocol SettingsTableViewControllerDelegate: AnyObject {
    
    /// Был изменен switch "Расширенный режим"
    ///
    /// - Parameter isOn: значение switch
    func didPressSwitchIsDetailNews(isOn: Bool)
    
    /// Был изменен switch "Обновление по таймеру"
    ///
    /// - Parameters:
    ///   - isOn: значение switch
    ///   - tableView: tableView которую необходимо обновить
    ///   - currentValueTimer: текущее значение таймера
    func didPressSwitchIsTimer(isOn: Bool, tableView: UITableView, currentValueTimer: Int)
    
    /// Был изменен PickerView
    ///
    /// - Parameter currentValue: текукщее значение PickerView (после изменения)
    func didChangePickerView(currentValue: Int)
    
    /// Нажата кнопка очистки прочтенных новостей
    func didPressClearReadedNewsButton()
    
    /// Нажата кнопка очистки сохраненных новостей
    func didPressClearOfflineNews()
}
