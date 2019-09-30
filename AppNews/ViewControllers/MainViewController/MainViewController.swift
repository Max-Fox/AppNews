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
    //var news: [New]?
    var newsCD: [NewCoreData] = []
    var readedNews: [ReadedNews] = [] //Массив прочтенных новостей
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    var withDetail: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.workWithCoreData?.getAllNews(arrayNews: &newsCD)
        print("COUNT \(newsCD.count)")
        
        DispatchQueue.global().async {
            let tmpNews = self.receiver.getNews()
            if tmpNews.count != 0 {
                self.newsCD = tmpNews
                print("Перед сохранением: \(self.newsCD.count)")
            }
            DispatchQueue.main.sync {
                
                if tmpNews.count != 0 {
                   // self.workWithCoreData?.clearSaveNews()
                    self.workWithCoreData?.saveAllNews(arrayNewsForSave: self.newsCD)
                }
                self.newsTableView.reloadData()
            }
        }
        
        title = "Новости"
        
        newsTableView.register(UINib(nibName: "NewTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.refreshControl = myRefreshControl
        
        withDetail = UserDefaults.standard.value(forKey: "withDetail") as? Bool ?? false
        
        self.workWithCoreData?.getReadedNews(array: &readedNews)
        
        checkCurrentTimer()
        
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        DispatchQueue.global().async {
            self.newsCD = self.receiver.getNews()
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
            
            webVC.urlString = newsCD[index.row].link
            
            //readedNews.append(ReadedNews(id: (news?[index.row].getIdNew() ?? "")))
            let idNew = newsCD[index.row].getIdNew()
            
            self.workWithCoreData?.saveNew(id: idNew, readedNews: &readedNews)
            //saveNew(id: idNew, readedNews: &readedNews)
            newsTableView.reloadData()
            
        }
    }
    
    @objc func refreshDataNewsByTimer(){
        DispatchQueue.global().async {
            self.newsCD = self.receiver.getNews()
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
        return newsCD.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NewTableViewCell
        
        cell.titleLabel.text = newsCD[indexPath.row].title
        cell.authorLabel.text = newsCD[indexPath.row].autor
        
        //Проверка на то, какой режим включен (обычный или расширенный)
        if withDetail {
            cell.discriptionLabel.text = newsCD[indexPath.row].descriptionNew
        } else {
            cell.discriptionLabel.text = ""
        }
        //cell.imageStringUrl = newsCD[indexPath.row].image
        cell.imageData = newsCD[indexPath.row].image
        
        //Поиск в массиве прочтенных
        if readedNews.contains(where: { (New) -> Bool in
            return New.id == newsCD[indexPath.row].getIdNew()
        }) {
            cell.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "webSegue", sender: indexPath)
    }
}

extension MainViewController: SettingsProtocol {
    func didPressButtonClearSavedNews() {
        self.workWithCoreData?.clearSaveNews()
    }
    
    func didChangePickerView(currentValue: Int) {
        UserDefaults.standard.set(currentValue, forKey: "valueTimer")
        
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(currentValue), target: self, selector: #selector(refreshDataNewsByTimer), userInfo: nil, repeats: true)
    }
    
    func didPressSwitchIsTimer(isOn: Bool, tableView: UITableView) {
        tableView.reloadData()
        UserDefaults.standard.set(isOn, forKey: "withTimer")
        if !isOn {
            timer.invalidate()
        }
    }
    
    func didPressSwitchIsDetailNews(isOn: Bool) {
        UserDefaults.standard.set(isOn, forKey: "withDetail")
        self.withDetail = isOn
        self.newsTableView.reloadData()
    }
}
