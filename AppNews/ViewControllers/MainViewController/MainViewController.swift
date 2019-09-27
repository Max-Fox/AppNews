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
    
    let reuseIdentifier = "NewCell"
    let receiver = NewsReceiver()
    var news: [New]?
    var nowCurrentNews = 25
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    var withDetail: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.news = receiver.getNews()
        
        title = "Новости"
        
        newsTableView.register(UINib(nibName: "NewTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.refreshControl = myRefreshControl
        
        withDetail = UserDefaults.standard.value(forKey: "withDetail") as? Bool ?? false
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        self.news = self.receiver.getNews()
        newsTableView.reloadData()
        sender.endRefreshing()
    }
    
    func showMore(){
        if news?.count ?? 0 > nowCurrentNews {
            self.nowCurrentNews += 25
        }
        DispatchQueue.main.async {
            self.newsTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingSeque" {
            let settingVC = segue.destination as! SettingTableViewController
            settingVC.delegate = self
        }
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nowCurrentNews
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == nowCurrentNews - 1 {
            showMore()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NewTableViewCell
        
        cell.titleLabel.text = news?[indexPath.row].title
        cell.authorLabel.text = news?[indexPath.row].autor
        
        if withDetail {
            cell.discriptionLabel.text = news?[indexPath.row].description
        } else {
            cell.discriptionLabel.text = ""
        }
        cell.imageStringUrl = news?[indexPath.row].image
        
        return cell
    }
    
}

extension MainViewController: SettingsProtocol {
    func didPressSwitchIsDetailNews(isOn: Bool) {
        UserDefaults.standard.set(isOn, forKey: "withDetail")
        withDetail = isOn
        self.newsTableView.reloadData()
    }
}





