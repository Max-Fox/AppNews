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
    
    weak var delegate: SettingsTableViewControllerDelegate?
    
    let arrayValueTimer = [10, 20, 30, 50, 70]
    var setting = Settings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Настройки"
        
        self.switchIsDetail.isOn = setting.isDetail
        self.switchIsTimer.isOn = setting.isTimer
        let valueTimer = setting.valueTimer
        
        self.pickerViewTimer.delegate = self
        self.pickerViewTimer.dataSource = self
        
        self.pickerViewTimer.selectRow(arrayValueTimer.firstIndex(where: { (value) -> Bool in
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
    
    @IBAction func pushClearReadedNewsButton(_ sender: Any) {
        delegate?.didPressClearReadedNewsButton()
    }
    
    @IBAction func pushClearOfflineNewsButton(_ sender: Any) {
        delegate?.didPressClearOfflineNews()
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
