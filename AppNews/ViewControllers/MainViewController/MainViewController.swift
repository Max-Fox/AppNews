//
//  ViewController.swift
//  AppNews
//
//  Created by Максим Лисица on 26/09/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var newsTableView: UITableView!
    
    var workWithCoreData: WorkWithCoreData?
    var timer = Timer()
    let reuseIdentifier = "NewCell"
    let receiver = NewsReceiver()
    var news: [New]?
    var readedNews: [ReadedNews] = [] //Массив прочтенных новостей
    var offlineNew: [NewOffline] = []
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    var withDetail: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.news = receiver.getNews()
        workWithCoreData?.getAllOfflineNews(in: &offlineNew)
        
        title = "Главная"
        navigationItem.title = "Новости"
        
        newsTableView.register(UINib(nibName: "NewTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.refreshControl = myRefreshControl
        
        withDetail = UserDefaults.standard.value(forKey: "withDetail") as? Bool ?? false
        
        self.workWithCoreData?.getReadedNews(array: &readedNews)
        checkCurrentTimer()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        workWithCoreData?.getReadedNews(array: &readedNews)
        newsTableView.reloadData()
        
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        DispatchQueue.global().async {
            self.news = self.receiver.getNews()
            DispatchQueue.main.sync {
                self.newsTableView.reloadData()
                sender.endRefreshing()
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingSeque" {
            let settingVC = segue.destination as! SettingTableViewController
            settingVC.delegate = self
        }
        if segue.identifier == "webSegue" {
            let webVC = segue.destination as! WebViewController
            
            guard let index = (sender as? IndexPath) else { return }
            
            webVC.urlString = news?[index.row].link
            
            //readedNews.append(ReadedNews(id: (news?[index.row].getIdNew() ?? "")))
            guard let idNew = news?[index.row].getIdNew() else { return }
            
            self.workWithCoreData?.saveNew(id: idNew, readedNews: &readedNews)
            //saveNew(id: idNew, readedNews: &readedNews)
            newsTableView.reloadData()
            
        }
    }
    
    @objc func refreshDataNewsByTimer(){
        DispatchQueue.global().async {
            self.news = self.receiver.getNews()
            DispatchQueue.main.sync {
                self.newsTableView.reloadData()
            }
        }
        print("Update")
    }
    
    func checkCurrentTimer(){
        let isTimer = UserDefaults.standard.value(forKey: "withTimer") as? Bool ?? false
        let timerValue = UserDefaults.standard.value(forKey: "valueTimer") as? Int ?? 0
        
        if isTimer && timerValue != 0 {
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(timerValue), target: self, selector: #selector(refreshDataNewsByTimer), userInfo: nil, repeats: true)
        }
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NewTableViewCell
        
        cell.titleLabel.text = news?[indexPath.row].title
        cell.authorLabel.text = news?[indexPath.row].autor
        
        //Проверка на то, какой режим включен (обычный или расширенный)
        if withDetail {
            cell.discriptionLabel.text = news?[indexPath.row].description
        } else {
            cell.discriptionLabel.text = ""
        }
        cell.imageStringUrl = news?[indexPath.row].image
        
        //Поиск в массиве прочтенных
        if readedNews.contains(where: { (New) -> Bool in
            return New.id == news?[indexPath.row].getIdNew()
        }) {
            cell.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        
        if offlineNew.contains(where: { (offNew) -> Bool in
            return offNew.title == news?[indexPath.row].title
        }) {
            cell.isOffline = true
        } else {
            cell.isOffline = false
        }
        
        cell.indexNew = indexPath
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "webSegue", sender: indexPath)
    }
}

extension MainViewController: SettingsProtocol {
    func didPushClearReadedNewsButton() {
        workWithCoreData?.deleteAllReadedNews()
        print("Удалены прочтенные новости")
    }
    
    func didChangePickerView(currentValue: Int) {
        UserDefaults.standard.set(currentValue, forKey: "valueTimer")
        
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(currentValue), target: self, selector: #selector(refreshDataNewsByTimer), userInfo: nil, repeats: true)
    }
    
    func didPressSwitchIsTimer(isOn: Bool, tableView: UITableView, currentValueTimer: Int) {
        tableView.reloadData()
        UserDefaults.standard.set(isOn, forKey: "withTimer")
        if !isOn {
            timer.invalidate()
        } else {
            UserDefaults.standard.set(currentValueTimer, forKey: "valueTimer")
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(currentValueTimer), target: self, selector: #selector(refreshDataNewsByTimer), userInfo: nil, repeats: true)
        }
        
    }
    
    func didPressSwitchIsDetailNews(isOn: Bool) {
        UserDefaults.standard.set(isOn, forKey: "withDetail")
        self.withDetail = isOn
        self.newsTableView.reloadData()
    }
}

extension MainViewController: TableViewCellProtocol {
    func didPressToSaveNew(indexNew: IndexPath, button: UIButton, isOffline: Bool) {
        guard let newForSave = news?[indexNew.row] else { return }
        
        if isOffline {
            self.workWithCoreData?.deleteNewOffline(new: newForSave)
            button.setImage(#imageLiteral(resourceName: "add_to_favorites"), for: .normal)
        } else {
            self.workWithCoreData?.saveNewInOffline(new: newForSave, newsOffline: &offlineNew)
            button.setImage(#imageLiteral(resourceName: "remove_to_favorites"), for: .normal)
        }
        
        newsTableView.reloadRows(at: [indexNew], with: .automatic)
    }
}
