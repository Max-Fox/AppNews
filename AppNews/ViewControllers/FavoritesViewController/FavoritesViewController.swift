//
//  OfflineViewController.swift
//  AppNews
//
//  Created by Максим Лисица on 30/09/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import UIKit

/// Экран с избранными новостями
class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableViewOfflineNews: UITableView!
    
    /// Работа с CoreData
    var coreDataManager: CoreDataManager?
    /// Список сохраненных новостей
    private var offlineNews: [NewOffline] = []
    /// Список прочитанных новостей
    private var readedNews: [ReadedNews] = []
    /// Идентификатор ячейки
    private let reuseIdentifier = "NewFavoriteCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Избранное"
        self.coreDataManager?.getAllOfflineNews(in: &offlineNews)
        self.coreDataManager?.getReadedNews(array: &readedNews)
        self.tableViewOfflineNews.register(UINib(nibName: "FavoritesNewTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        self.tableViewOfflineNews.delegate = self
        self.tableViewOfflineNews.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.coreDataManager?.getAllOfflineNews(in: &offlineNews)
        self.coreDataManager?.getReadedNews(array: &readedNews)
        self.tableViewOfflineNews.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webFavoriteSegue" {
            let webVC = segue.destination as! WebViewController
            
            guard let index = (sender as? IndexPath) else { return }
            
            webVC.urlString = offlineNews[index.row].link
            
            guard let identifier = offlineNews[index.row].getIdentifier() else { return }
            self.coreDataManager?.saveNew(id: identifier, readedNews: &readedNews)
            self.tableViewOfflineNews.reloadData()
        }
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offlineNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FavoritesNewTableViewCell
        
        let newsItem = offlineNews[indexPath.row]
        
        cell.titleLabel.text = newsItem.title
        cell.authorLabel.text = newsItem.autor
        cell.descriptionLabel.text = newsItem.descriptionNew
        cell.isOffline = true
        cell.delegate = self
        cell.indexNew = indexPath
        
        //Поиск в массиве прочтенных
        if readedNews.contains(where: { (New) -> Bool in
            return New.id == newsItem.getIdentifier()
        }) {
            cell.backgroundColor = #colorLiteral(red: 0.8392160535, green: 0.8392160535, blue: 0.8392160535, alpha: 1)
        }
        
        guard let data = newsItem.image else { return cell }
        
        cell.imageViewNew.image = UIImage(data: data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "webFavoriteSegue", sender: indexPath)
    }
}

extension FavoritesViewController: NewsTableViewCellDelegate {
    func didPressToSaveNew(indexNew: IndexPath, button: UIButton, isOffline: Bool) {
        coreDataManager?.deleteNewOffline(newOffline: offlineNews[indexNew.row])
        offlineNews.remove(at: indexNew.row)
        tableViewOfflineNews.reloadData()
    }
}
