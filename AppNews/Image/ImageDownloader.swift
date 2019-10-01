//
//  ImageDownloader.swift
//  AppNews
//
//  Created by Максим Лисица on 01/10/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import UIKit

class ImageDownloader {
    /// Загрузка изображения по url
    ///
    /// - Parameters:
    ///   - stringUrl: url в формате string
    ///   - completion: блок возвращает UIImage - изображение, String - строку адреса URL, Bool - результат выполнения
    func loadImageByUrl(stringUrl: String, completion: @escaping (UIImage?, String?, Bool) -> ()) {
        DispatchQueue.global().async {
            guard let url = URL(string: stringUrl) else {
                completion(nil, nil, false)
                return
            }
            do {
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else {
                    completion(nil, nil, false)
                    return
                }
                DispatchQueue.main.async {
                    completion(image, stringUrl, true)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
