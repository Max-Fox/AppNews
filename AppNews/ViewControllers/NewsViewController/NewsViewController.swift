//
//  ViewController.swift
//  AppNews
//
//  Created by Максим Лисица on 26/09/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import UIKit

/// Главный экран с новостями
class NewsViewController: UIViewController {
    
    @IBOutlet weak var newsTableView: UITableView!
    
    /// Объект для работы с CoreData
    var coreDataManager: CoreDataManager?
    /// Объект для загрузки изображений
    var imageDownloader: ImageDownloader?
    /// Таймер обновления новостей
    private var timer = Timer()
    /// Идентификатор ячейки
    private let reuseIdentifier = "NewCell"
    /// Ресивер ( получатель новостей )
    var receiver: NewsReceiverProtocol?
    /// Массив новостей
    private var news: [NewsItem]?
    /// Массив прочтенных новостей
    private var readedNews: [ReadedNews] = []
    /// Массив сохраненных новостей
    private var offlineNew: [NewOffline] = []
    /// Настройки
    var settings: Settings?
    /// RefreshControl для Pull to Refresh
    private let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.news = receiver?.obtainNews()
        self.coreDataManager?.getAllOfflineNews(in: &offlineNew)
        
        title = "Главная"
        navigationItem.title = "Новости"
        
        self.newsTableView.register(UINib(nibName: "NewTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        self.newsTableView.delegate = self
        self.newsTableView.dataSource = self
        self.newsTableView.refreshControl = myRefreshControl
        self.coreDataManager?.getReadedNews(array: &readedNews)
        checkCurrentTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.coreDataManager?.getReadedNews(array: &readedNews)
        self.newsTableView.reloadData()
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        DispatchQueue.global().async {
            self.news = self.receiver?.obtainNews()
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
            settingVC.settings = self.settings
        }
        if segue.identifier == "webSegue" {
            let webVC = segue.destination as! WebViewController
            
            guard let index = (sender as? IndexPath), let idNew = news?[index.row].getIdentifier() else { return }
            
            webVC.urlString = news?[index.row].link
            self.coreDataManager?.saveNew(id: idNew, readedNews: &readedNews)
            self.newsTableView.reloadData()
        }
    }
    
    @objc func refreshDataNewsByTimer(){
        DispatchQueue.global().async {
            self.news = self.receiver?.obtainNews()
            DispatchQueue.main.sync {
                self.newsTableView.reloadData()
            }
        }
    }
    
    /// Проверка, установлен ли таймер на обновление
    func checkCurrentTimer(){
        let isTimer = settings?.isTimer ?? false
        let timerValue = settings?.valueTimer
        if isTimer && timerValue != nil {
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(timerValue!), target: self, selector: #selector(refreshDataNewsByTimer), userInfo: nil, repeats: true)
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
        cell.authorLabel.text = newsItem.author
        
        //Проверка на то, какой режим включен (обычный или расширенный)
        if settings?.isDetail ?? false {
            cell.descriptionLabel.text = newsItem.description
        } else {
            cell.descriptionLabel.text = ""
        }
        cell.imageStringUrl = newsItem.pathToImage
        
        //Поиск в массиве прочтенных
        if readedNews.contains(where: { (New) -> Bool in
            return New.id == newsItem.getIdentifier()
        }) {
            cell.backgroundColor = #colorLiteral(red: 0.8392160535, green: 0.8392160535, blue: 0.8392160535, alpha: 1)
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
        
        guard let pathToImage = newsItem.pathToImage else { return cell }
        
        imageDownloader?.loadImageByUrl(stringUrl: pathToImage) { (image, urlString, success)  in
            if let image = image {
                if urlString == newsItem.pathToImage {
                    cell.imageNew = image
                } else {
                    cell.imageViewNew.image = nil
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "webSegue", sender: indexPath)
    }
}

extension NewsViewController: SettingsTableViewControllerDelegate {
    func didPressClearOfflineNews() {
        self.coreDataManager?.deleteAllOfflineNews()
    }
    
    func didPressClearReadedNewsButton() {
        self.coreDataManager?.deleteAllReadedNews()
    }
    
    func didChangePickerView(currentValue: Int) {
        self.settings?.valueTimer = currentValue
        self.timer.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(currentValue), target: self, selector: #selector(refreshDataNewsByTimer), userInfo: nil, repeats: true)
    }
    
    func didPressSwitchIsTimer(isOn: Bool, tableView: UITableView, currentValueTimer: Int) {
        tableView.reloadData()
        self.settings?.isTimer = isOn
        if !isOn {
            self.timer.invalidate()
        } else {
            self.settings?.valueTimer = currentValueTimer
            
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(currentValueTimer), target: self, selector: #selector(refreshDataNewsByTimer), userInfo: nil, repeats: true)
        }
    }
    
    func didPressSwitchIsDetailNews(isOn: Bool) {
        self.settings?.isDetail = isOn
        self.newsTableView.reloadData()
    }
}

extension NewsViewController: NewsTableViewCellDelegate {
    func didPressToSaveNew(indexNew: IndexPath, button: UIButton, isOffline: Bool) {
        guard let newForSave = news?[indexNew.row] else { return }
        
        if isOffline {
            self.coreDataManager?.deleteNewOffline(new: newForSave)
            button.setImage(#imageLiteral(resourceName: "add_to_favorites"), for: .normal)
        } else {
            self.coreDataManager?.saveNewInOffline(new: newForSave, newsOffline: &offlineNew)
            button.setImage(#imageLiteral(resourceName: "remove_to_favorites"), for: .normal)
        }
        self.newsTableView.reloadRows(at: [indexNew], with: .automatic)
    }
}
