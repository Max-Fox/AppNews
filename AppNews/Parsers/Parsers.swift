//
//  Parsers.swift
//  AppNews
//
//  Created by Максим Лисица on 26/09/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import Foundation

func parserNewsGazeta() -> [New] {
    let stringUrl = "https://www.gazeta.ru/export/rss/lenta.xml"
    
    guard let url = URL(string: stringUrl) else { return [New()] }
    
    let parserNewsGazeta = ParserNewsGazeta()
    let parser = XMLParser(contentsOf: url)
    parser?.delegate = parserNewsGazeta
    parser?.parse()
    
    return parserNewsGazeta.arrayNews
}


func parserNewsLenta() -> [New] {
    let stringUrl = "https://lenta.ru/rss"
    
    guard let url = URL(string: stringUrl) else { return [New()]}
    
    let parserNewsLenta = ParserNewsLenta()
    let parser = XMLParser(contentsOf: url)
    parser?.delegate = parserNewsLenta
    parser?.parse()
    
    return parserNewsLenta.arrayNews
}
