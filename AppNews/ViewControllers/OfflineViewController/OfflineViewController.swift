//
//  OfflineViewController.swift
//  AppNews
//
//  Created by Максим Лисица on 30/09/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import UIKit

class OfflineViewController: UIViewController {
    @IBOutlet weak var tableViewOfflineNews: UITableView!
    
    var workWithCoreData: WorkWithCoreData?
    var offlineNews: [NewOffline] = []
    var readedNews: [ReadedNews] = []
    let reuseIdentifier = "NewOfflineCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Избранное"
        workWithCoreData?.getAllOfflineNews(in: &offlineNews)
        self.workWithCoreData?.getReadedNews(array: &readedNews)
        
        tableViewOfflineNews.register(UINib(nibName: "OfflineNewTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        tableViewOfflineNews.delegate = self
        tableViewOfflineNews.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        workWithCoreData?.getAllOfflineNews(in: &offlineNews)
        workWithCoreData?.getReadedNews(array: &readedNews)
        tableViewOfflineNews.reloadData()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webOfflineSegue" {
            let webVC = segue.destination as! WebViewController
            
            guard let index = (sender as? IndexPath) else { return }
            
            webVC.urlString = offlineNews[index.row].link
            
            //readedNews.append(ReadedNews(id: (news?[index.row].getIdNew() ?? "")))
            //guard let idNew = offlineNews[index.row].getIdNew() else { return }
            
            self.workWithCoreData?.saveNew(id: offlineNews[index.row].getIdNew(), readedNews: &readedNews)
            //saveNew(id: idNew, readedNews: &readedNews)
            tableViewOfflineNews.reloadData()
            
            //readedNews.append(ReadedNews(id: (news?[index.row].getIdNew() ?? "")))
//            guard let idNew = news?[index.row].getIdNew() else { return }
//
//            self.workWithCoreData?.saveNew(id: idNew, readedNews: &readedNews)
//            //saveNew(id: idNew, readedNews: &readedNews)
//            newsTableView.reloadData()
            
        }
    }
    
}
extension OfflineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offlineNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! OfflineNewTableViewCell
        
        cell.titleLabel.text = offlineNews[indexPath.row].title
        cell.authorLabel.text = offlineNews[indexPath.row].autor
        cell.discriptionLabel.text = offlineNews[indexPath.row].descriptionNew
        cell.isOffline = true
        cell.delegate = self
        cell.indexNew = indexPath
        
        //Поиск в массиве прочтенных
        if readedNews.contains(where: { (New) -> Bool in
            return New.id == offlineNews[indexPath.row].getIdNew()
        }) {
            cell.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        
        guard let data = offlineNews[indexPath.row].image else { return cell }
        
        cell.imageViewNew.image = UIImage(data: data)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "webOfflineSegue", sender: indexPath)
    }
    
    
}
extension OfflineViewController: TableViewCellProtocol {
    func didPressToSaveNew(indexNew: IndexPath, button: UIButton, isOffline: Bool) {
        workWithCoreData?.deleteNewOffline(newOffline: offlineNews[indexNew.row])
        offlineNews.remove(at: indexNew.row)
        tableViewOfflineNews.reloadData()
    }
    
    
}
