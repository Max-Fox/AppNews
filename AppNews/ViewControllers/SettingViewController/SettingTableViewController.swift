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
    @IBOutlet weak var switchIsTimer: UISwitch!
    
    @IBOutlet weak var pickerViewTimer: UIPickerView!
    @IBOutlet weak var cellWithTimer: UITableViewCell!
    
    var delegate: SettingsProtocol?
    
    let arrayValueTimer = [10, 20, 30, 50, 70]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Настройки"
        
        switchIsDetail.isOn = UserDefaults.standard.value(forKey: "withDetail") as? Bool ?? false
        switchIsTimer.isOn = UserDefaults.standard.value(forKey: "withTimer") as? Bool ?? false
        let valueTimer = UserDefaults.standard.value(forKey: "valueTimer") as? Int ?? 0
        
        pickerViewTimer.delegate = self
        pickerViewTimer.dataSource = self
        
        pickerViewTimer.selectRow(arrayValueTimer.firstIndex(where: { (value) -> Bool in
            return value == valueTimer
        }) ?? 0, inComponent: 0, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 && switchIsTimer.isOn {
            return 214
        }
        return 44
    }
    
    @IBAction func pushSwitchIsDetailAction(_ sender: UISwitch) {
        delegate?.didPressSwitchIsDetailNews(isOn: sender.isOn)
    }
    @IBAction func pushSwitchIsTimerAction(_ sender: UISwitch) {
        delegate?.didPressSwitchIsTimer(isOn: sender.isOn, tableView: tableView, currentValueTimer: arrayValueTimer[pickerViewTimer.selectedRow(inComponent: 0)])
    }
}

extension SettingTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayValueTimer.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let title = "\(arrayValueTimer[row]) секунд"
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.didChangePickerView(currentValue: arrayValueTimer[row])
    }
}
