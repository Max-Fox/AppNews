//
//  TableVIewCellProtocol.swift
//  AppNews
//
//  Created by Максим Лисица on 30/09/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import UIKit

/// Протокол для ячейки новости
protocol NewsTableViewCellDelegate: AnyObject {
    /// Обрабатывает нажатие на кнопку добавить в избранное ячейки
    ///
    /// - Parameters:
    ///   - indexNew: индекс элемента в массиве
    ///   - button: кнопка, которую необходимо изменить
    ///   - isOffline: переменная, которая определяет доступен ли этот элемент оффлайн
    func didPressToSaveNew(indexNew: IndexPath, button: UIButton, isOffline: Bool)
}
