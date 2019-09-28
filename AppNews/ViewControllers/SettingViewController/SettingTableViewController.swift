//
//  SettingTableViewController.swift
//  AppNews
//
//  Created by Максим Лисица on 27/09/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
    @IBOutlet weak var switchIsDetail: UISwitch!
    
    var delegate: SettingsProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Настройки"
        
        switchIsDetail.isOn = UserDefaults.standard.value(forKey: "withDetail") as? Bool ?? false
    }
    
    @IBAction func pushSwitchAction(_ sender: UISwitch!) {
        delegate?.didPressSwitchIsDetailNews(isOn: sender.isOn)
    }
}
