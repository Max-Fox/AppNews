//
//  SettingsProtocol.swift
//  AppNews
//
//  Created by Максим Лисица on 27/09/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import UIKit

protocol SettingsTableViewControllerDelegate: AnyObject {
    func didPressSwitchIsDetailNews(isOn: Bool)
    func didPressSwitchIsTimer(isOn: Bool, tableView: UITableView, currentValueTimer: Int)
    func didChangePickerView(currentValue: Int)
    func didPressClearReadedNewsButton()
    func didPressClearOfflineNews()
}
