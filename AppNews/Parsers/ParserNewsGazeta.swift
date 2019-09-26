//
//  ParserNewsGazeta.swift
//  AppNews
//
//  Created by Максим Лисица on 26/09/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import Foundation

class ParserNewsGazeta: NSObject, XMLParserDelegate {
    var arrayNews: [New] = []
    var currentNew: New?
    
    //Когда находит открывающийся тег
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "item" {
            currentNew = New()
        }
        
        if elementName == "enclosure" {
            if let currentUrlImage = attributeDict["url"] {
                currentNew?.image = currentUrlImage
            }
        }
    }
    
    //Символы между тегами
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
            currentNew?.autor = currentCharacters
        }
        if elementName == "pubDate" {
            currentNew?.pubDate = currentCharacters
        }
        if elementName == "description" {
            currentNew?.description = currentCharacters
        }
        if elementName == "item" {
            arrayNews.append(currentNew!)
        }
    }
}
