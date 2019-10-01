//
//  SettingTableViewController.swift
//  AppNews
//
//  Created by Максим Лисица on 27/09/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import UIKit

/// Экран настроек
class SettingTableViewController: UITableViewController {
    
    @IBOutlet weak var switchIsDetail: UISwitch!
    @IBOutlet weak var switchIsTimer: UISwitch!
    @IBOutlet weak var pickerViewTimer: UIPickerView!
    @IBOutlet weak var cellWithTimer: UITableViewCell!
    
    weak var delegate: SettingsTableViewControllerDelegate?
    
    var settings: Settings?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Настройки"
        
        self.switchIsDetail.isOn = settings?.isDetail ?? false
        self.switchIsTimer.isOn = settings?.isTimer ?? false
        let valueTimer = settings?.valueTimer
        
        self.pickerViewTimer.delegate = self
        self.pickerViewTimer.dataSource = self
        
        self.pickerViewTimer.selectRow(settings?.arrayValueTimer.firstIndex(where: { (value) -> Bool in
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
        delegate?.didPressSwitchIsTimer(isOn: sender.isOn, tableView: tableView, currentValueTimer: settings?.arrayValueTimer[pickerViewTimer.selectedRow(inComponent: 0)] ?? 10)
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
        return settings?.arrayValueTimer.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let title = "\(settings?.arrayValueTimer[row] ?? 10) секунд"
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.didChangePickerView(currentValue: settings?.arrayValueTimer[row] ?? 10)
    }
}
