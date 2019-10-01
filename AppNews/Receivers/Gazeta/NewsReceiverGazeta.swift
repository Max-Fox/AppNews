//
//  NewsReceiverGazeta.swift
//  AppNews
//
//  Created by Максим Лисица on 26/09/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import Foundation

/// Ресивер ( получатель ) новостей Gazeta
class NewsReceiverGazeta: NewsReceiverProtocol {
    
    let stringUrl = "https://www.gazeta.ru/export/rss/lenta.xml"
    
    func obtainNews() -> [NewsItem] {
        
        guard let url = URL(string: self.stringUrl) else { return [NewsItem()] }
        
        let parserNewsGazeta = ParserNewsGazeta()
        let parser = XMLParser(contentsOf: url)
        parser?.delegate = parserNewsGazeta
        parser?.parse()
        
        let news = parserNewsGazeta.arrayNews
        
        return news
    }
}
