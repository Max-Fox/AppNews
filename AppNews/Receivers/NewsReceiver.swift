//
//  NewsReceiver.swift
//  AppNews
//
//  Created by Максим Лисица on 26/09/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import Foundation

class NewsReceiver {
    
    var news: [New]?
    let receiverGazeta = NewsReceiverGazeta()
    let receiverLenta = NewsReceiverLenta()
    
    func getNews() -> [New] {
        let newsGazeta = receiverGazeta.obtainNews()
        let newsLenta = receiverLenta.obtainNews()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss +zzzz"
        dateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
        news = newsGazeta + newsLenta
        
        // убрать !
        news?.sort(by: { (a, b) -> Bool in
            let dateA = dateFormatter.date(from: a.pubDate!)
            let dateB = dateFormatter.date(from: b.pubDate!)
            return dateA! > dateB!
        })
        
        return news!
    }
}
