//
//  New.swift
//  AppNews
//
//  Created by Максим Лисица on 26/09/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import Foundation

class New {
    var title: String?
    var link: String?
    var autor: String?
    var pubDate: String?
    var description: String?
    var image: String?
    
    func getIdNew() -> String {
//        guard let date = self.pubDate, let name = self.title, let fCharacterName = name.first else { return "nil" }
        //let id = "\(date)_\(fCharacterName)"
        guard let id = link else { return "nil"}
    
        return id
    }
}

extension NewOffline {
    func getIdNew() -> String {
        guard let id = link else { return "nil"}
        
        return id
    }
}
