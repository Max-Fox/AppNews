//
//  SettingsProtocol.swift
//  AppNews
//
//  Created by Максим Лисица on 27/09/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import UIKit

protocol SettingsProtocol {
    func didPressSwitchIsDetailNews(isOn: Bool)
    func didPressSwitchIsTimer(isOn: Bool, tableView: UITableView)
    func didChangePickerView(currentValue: Int)
}
