//
//  NewsReceiverLenta.swift
//  AppNews
//
//  Created by Максим Лисица on 26/09/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import Foundation

/// Ресивер ( получатель ) новостей Lenta
class NewsReceiverLenta: NewsReceiverProtocol {
    
    let stringUrl = "https://lenta.ru/rss"
    
    func obtainNews() -> [NewsItem] {
        
        guard let url = URL(string: self.stringUrl) else { return [NewsItem()]}
        
        let parserNewsLenta = ParserNewsLenta()
        let parser = XMLParser(contentsOf: url)
        parser?.delegate = parserNewsLenta
        parser?.parse()
        
        let news = parserNewsLenta.arrayNews
        
        return news
    }
}
