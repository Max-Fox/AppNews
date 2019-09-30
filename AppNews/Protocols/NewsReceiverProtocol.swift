//
//  NewsReceiveProtocol.swift
//  AppNews
//
//  Created by Максим Лисица on 26/09/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import Foundation

protocol NewsReceiverProtocol {
    func obtainNews() -> [NewCoreData]
}
