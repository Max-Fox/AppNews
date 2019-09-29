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
    
    let reuseIdentifier = "NewCell"
    let receiver = NewsReceiver()
    var news: [New]?
    var readedNews: [ReadedNews] = [] //Массив прочтенных новостей
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    var withDetail: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.news = receiver.getNews()
        
        title = "Новости"
        
        newsTableView.register(UINib(nibName: "NewTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.refreshControl = myRefreshControl
        
        withDetail = UserDefaults.standard.value(forKey: "withDetail") as? Bool ?? false
        
        self.workWithCoreData?.getReadedNews(array: &readedNews)
        
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
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "webSegue", sender: indexPath)
    }
}

extension MainViewController: SettingsProtocol {
    func didPressSwitchIsDetailNews(isOn: Bool) {
        UserDefaults.standard.set(isOn, forKey: "withDetail")
        self.withDetail = isOn
        self.newsTableView.reloadData()
    }
}
