//
//  NewsReceiver.swift
//  AppNews
//
//  Created by Максим Лисица on 26/09/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import Foundation

class NewsReceiver: NewsReceiverProtocol {
    
    var news: [New]?
    let receiverGazeta = NewsReceiverGazeta()
    let receiverLenta = NewsReceiverLenta()
    
    func obtainNews() -> [New] {
        let newsGazeta = receiverGazeta.obtainNews()
        let newsLenta = receiverLenta.obtainNews()
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
        
        return news ?? [New()]
    }
}
