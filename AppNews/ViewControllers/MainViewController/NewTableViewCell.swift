//
//  NewTableViewCell.swift
//  AppNews
//
//  Created by Максим Лисица on 26/09/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import UIKit

class NewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageViewNew: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    
    var imageStringUrl: String?
    var imageData: Data?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageViewNew.image = nil
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //self.imageActivityIndicator.isHidden = false
        //imageActivityIndicator.startAnimating()
        self.imageViewNew.contentMode = .scaleAspectFill
        //loadImageByUrl()
        loadImageByData()
    }
    
    func loadImageByData() {
        guard let imageData = imageData else { return }
        self.imageViewNew.image = UIImage(data: imageData)
    }
    
    func loadImageByUrl(){
        DispatchQueue.global().async {
            guard let stringUrl = self.imageStringUrl ,let url = URL(string: stringUrl) else { return }
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                DispatchQueue.main.sync {
                    self.imageViewNew.image = image
                    self.imageActivityIndicator.stopAnimating()
                    self.imageActivityIndicator.isHidden = true
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
