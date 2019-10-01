//
//  ViewController.swift
//  AppNews
//
//  Created by Максим Лисица on 26/09/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    
    @IBOutlet weak var newsTableView: UITableView!
    
    var workWithCoreData: WorkWithCoreData?
    var timer = Timer()
    let reuseIdentifier = "NewCell"
    let receiver = NewsReceiver()
    var news: [New]?
    var readedNews: [ReadedNews] = [] //Массив прочтенных новостей
    var offlineNew: [NewOffline] = []
    var setting = Setting()
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    var withDetail: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.news = receiver.getNews()
        self.workWithCoreData?.getAllOfflineNews(in: &offlineNew)
        
        title = "Главная"
        navigationItem.title = "Новости"
        
        self.newsTableView.register(UINib(nibName: "NewTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        self.newsTableView.delegate = self
        self.newsTableView.dataSource = self
        self.newsTableView.refreshControl = myRefreshControl
        //self.withDetail = UserDefaults.standard.value(forKey: "withDetail") as? Bool ?? false
        self.workWithCoreData?.getReadedNews(array: &readedNews)
        checkCurrentTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.workWithCoreData?.getReadedNews(array: &readedNews)
        self.newsTableView.reloadData()
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
            
            guard let index = (sender as? IndexPath), let idNew = news?[index.row].getIdNew() else { return }
            
            webVC.urlString = news?[index.row].link
            self.workWithCoreData?.saveNew(id: idNew, readedNews: &readedNews)
            self.newsTableView.reloadData()
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
        let isTimer = setting.getIsTimer()
        let timerValue = setting.getValueTimer()
        
        if isTimer && timerValue != 0 {
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(timerValue), target: self, selector: #selector(refreshDataNewsByTimer), userInfo: nil, repeats: true)
        }
    }
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NewTableViewCell
        
        guard let newsItem = news?[indexPath.row] else { return cell }
        
        cell.titleLabel.text = newsItem.title
        cell.authorLabel.text = newsItem.autor
        
        //Проверка на то, какой режим включен (обычный или расширенный)
        if withDetail {
            cell.discriptionLabel.text = newsItem.description
        } else {
            cell.discriptionLabel.text = ""
        }
        cell.imageStringUrl = newsItem.image
        
        //Поиск в массиве прочтенных
        if readedNews.contains(where: { (New) -> Bool in
            return New.id == newsItem.getIdNew()
        }) {
            cell.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        
        //Поиск в массиве сохраненных
        if offlineNew.contains(where: { (offNew) -> Bool in
            return offNew.title == newsItem.title
        }) {
            cell.isOffline = true
        } else {
            cell.isOffline = false
        }
        
        cell.indexNew = indexPath
        cell.delegate = self
        
        cell.imageViewNew.image = nil
        
        guard let imageStringUrl = newsItem.image else { return cell }
        
        loadImageByUrl(stringUrl: imageStringUrl) { (image, urlString) in
            if urlString == newsItem.image {
                cell.imageViewNew.image = image
            } else {
                cell.imageViewNew.image = nil
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "webSegue", sender: indexPath)
    }
    
    func loadImageByUrl(stringUrl: String, complition: @escaping (UIImage, String)->()) {
        DispatchQueue.global().async {
            
            guard let url = URL(string: stringUrl) else { return }
            do {
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else { return }
               
                DispatchQueue.main.async {
                    complition(image, stringUrl)
//                    self.imageViewNew.image = image
//                    self.imageActivityIndicator.stopAnimating()
//                    self.imageActivityIndicator.isHidden = true
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }

    
}

extension NewsViewController: SettingsProtocol {
    func didPressClearOfflineNews() {
        workWithCoreData?.deleteAllOfflineNews()
    }
    
    func didPressClearReadedNewsButton() {
        workWithCoreData?.deleteAllReadedNews()
    }
    
    func didChangePickerView(currentValue: Int) {
        setting.setValueTimer(with: currentValue)
        //UserDefaults.standard.set(currentValue, forKey: "valueTimer")
        self.timer.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(currentValue), target: self, selector: #selector(refreshDataNewsByTimer), userInfo: nil, repeats: true)
    }
    
    func didPressSwitchIsTimer(isOn: Bool, tableView: UITableView, currentValueTimer: Int) {
        tableView.reloadData()
        setting.setIsTimer(with: isOn)
        //UserDefaults.standard.set(isOn, forKey: "withTimer")
        if !isOn {
            timer.invalidate()
        } else {
            setting.setValueTimer(with: currentValueTimer)
            //UserDefaults.standard.set(currentValueTimer, forKey: "valueTimer")
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(currentValueTimer), target: self, selector: #selector(refreshDataNewsByTimer), userInfo: nil, repeats: true)
        }
    }
    
    func didPressSwitchIsDetailNews(isOn: Bool) {
        setting.setIsDetail(with: isOn)
        //UserDefaults.standard.set(isOn, forKey: "withDetail")
        self.withDetail = isOn
        self.newsTableView.reloadData()
    }
}

extension NewsViewController: TableViewCellProtocol {
    func didPressToSaveNew(indexNew: IndexPath, button: UIButton, isOffline: Bool) {
        guard let newForSave = news?[indexNew.row] else { return }
        
        if isOffline {
            self.workWithCoreData?.deleteNewOffline(new: newForSave)
            button.setImage(#imageLiteral(resourceName: "add_to_favorites"), for: .normal)
        } else {
            self.workWithCoreData?.saveNewInOffline(new: newForSave, newsOffline: &offlineNew)
            button.setImage(#imageLiteral(resourceName: "remove_to_favorites"), for: .normal)
        }
        self.newsTableView.reloadRows(at: [indexNew], with: .automatic)
    }
}
