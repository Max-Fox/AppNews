//
//  ImageDownloader.swift
//  AppNews
//
//  Created by Максим Лисица on 01/10/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import UIKit

class ImageDownloader {
    func loadImageByUrl(stringUrl: String, complition: @escaping (UIImage, String)->()) {
        DispatchQueue.global().async {
            guard let url = URL(string: stringUrl) else { return }
            do {
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    complition(image, stringUrl)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
