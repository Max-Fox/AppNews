//
//  New.swift
//  AppNews
//
//  Created by Максим Лисица on 26/09/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import Foundation

class NewsItem {
    var title: String?
    var link: String?
    var author: String?
    var pubDate: String?
    var description: String?
    var pathToImage: String?
    
    func getIdentifier() -> String? {
        guard let id = link else { return nil }
        return id
    }
}
