//
//  NewsReceiver.swift
//  AppNews
//
//  Created by Максим Лисица on 26/09/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import Foundation

class NewsReceiver: NewsReceiverProtocol {
    
    var news: [NewsItem]?
    let receiverGazeta = NewsReceiverGazeta()
    let receiverLenta = NewsReceiverLenta()
    
    func obtainNews() -> [NewsItem] {
        var newsGazeta: [NewsItem] = []
        var newsLenta: [NewsItem] = []
        
        let queueConcurrent = DispatchQueue(label: "Obtain News", attributes: .concurrent)
        let group = DispatchGroup()
        
        group.enter()
        queueConcurrent.async {
            newsGazeta = self.receiverGazeta.obtainNews()
            group.leave()
        }
        
        group.enter()
        queueConcurrent.async {
            newsLenta = self.receiverLenta.obtainNews()
            group.leave()
        }
        
        group.wait()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss +zzzz"
        dateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
        news = newsGazeta + newsLenta
        
        news?.sort(by: { (a, b) -> Bool in
            guard let pubDateA = a.pubDate, let pubDateB = b.pubDate else { return false}
            let dateA = dateFormatter.date(from: pubDateA)
            let dateB = dateFormatter.date(from: pubDateB)
            return dateA ?? Date() > dateB ?? Date()
        })
        
        return news ?? [NewsItem()]
    }
}
