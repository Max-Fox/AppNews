//
//  New.swift
//  AppNews
//
//  Created by Максим Лисица on 26/09/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import Foundation

/// Класс новостей
class NewsItem {
    /// Заголовок новости
    var title: String?
    /// Ссылка на полную версию новости
    var link: String?
    /// Автор новости
    var author: String?
    /// Дата публикации
    var pubDate: String?
    /// Краткое описание новости
    var description: String?
    /// Путь к изображению
    var pathToImage: String?
    
    func getIdentifier() -> String? {
        guard let id = link else { return nil }
        return id
    }
}
