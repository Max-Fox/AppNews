//
//  TableVIewCellProtocol.swift
//  AppNews
//
//  Created by Максим Лисица on 30/09/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import UIKit

protocol TableViewCellProtocol {
    func didPressToSaveNew(indexNew: IndexPath, button: UIButton, isOffline: Bool)
}
