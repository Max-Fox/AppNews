//
//  ParserNewsLenta.swift
//  AppNews
//
//  Created by Максим Лисица on 26/09/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import Foundation

class ParserNewsLenta: NSObject, XMLParserDelegate {
    var arrayNews: [New] = []
    var currentNew: New?
    
    /*
     <item>
     <guid>https://lenta.ru/news/2019/09/26/gela/</guid>
     <title>В Белоруссии лидера воров в законе впервые освободили по амнистии</title>
     <link>https://lenta.ru/news/2019/09/26/gela/</link>
     <description>
     <![CDATA[Лидер мингрельского воровского клана, 45-летний Гела Кардава, известный в криминальных кругах как Гела Гальский, вошел в число двух тысяч образцовых заключенных, освобожденных по амнистии к 75-летию освобождения Белоруссии от немецко-фашистских захватчиков. Кардаве оставалось отбыть 16 месяцев лишения свободы.]]>
     </description>
     <pubDate>Thu, 26 Sep 2019 11:05:21 +0300</pubDate>
     <enclosure url="https://icdn.lenta.ru/images/2019/09/26/11/20190926110334907/pic_eed3ff1b89cd37aabd4faa344b280d23.jpg" type="image/jpeg" length="52142"/>
     <category>Силовые структуры</category>
     </item>
    */
    
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
