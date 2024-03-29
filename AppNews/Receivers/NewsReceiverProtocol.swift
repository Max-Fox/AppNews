//
//  NewsReceiveProtocol.swift
//  AppNews
//
//  Created by Максим Лисица on 26/09/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import Foundation

/// Протокол для ресивера (получателя) новостей
protocol NewsReceiverProtocol {
    
    /// Получить новости
    func obtainNews() -> [NewsItem]
}
