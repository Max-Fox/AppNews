//
//  ParserNewsLenta.swift
//  AppNews
//
//  Created by Максим Лисица on 26/09/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import Foundation

/// Парсер для сайта Lenta
class ParserNewsLenta: NSObject, XMLParserDelegate {
    
    var arrayNews: [NewsItem] = []
    var currentNew: NewsItem?
    /// Хранится блок CDATA, который присутствует в xml Ленты
    var currentDescription: String = ""
    
    //Когда находит открывающийся тег
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "item" {
            currentNew = NewsItem()
        }
        if elementName == "enclosure" {
            if let currentUrlImage = attributeDict["url"] {
                currentNew?.pathToImage = currentUrlImage
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        let description = String(data: CDATABlock, encoding: .utf8)
        currentDescription = description ?? ""
    }
    
    /// В эту переменную записывается текущий символ при парсинге
    var currentCharacters: String = ""
    func parser(_ parser: XMLParser, foundCharacters string: String){
        currentCharacters = string
    }
    
    //Когда находит закрывающийся тег
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        if elementName == "title" {
            currentNew?.title = currentCharacters
        }
        if elementName == "link" {
            currentNew?.link = currentCharacters
        }
        if elementName == "author" {
            currentNew?.author = currentCharacters
        }
        if elementName == "pubDate" {
            currentNew?.pubDate = currentCharacters
        }
        if elementName == "description" {
            currentNew?.description = currentDescription
        }
        if elementName == "item" {
            currentNew?.author = "Lenta.ru"
            arrayNews.append(currentNew!)
        }
    }
}
