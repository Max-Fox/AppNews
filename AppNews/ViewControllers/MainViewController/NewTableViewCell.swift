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
    
    var imageStringUrl: String?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
        self.imageViewNew.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageViewNew.contentMode = .scaleAspectFill
        loadImageByUrl()
        
       
    }
    
    func loadImageByUrl(){
        DispatchQueue.global().async {
            guard let stringUrl = self.imageStringUrl ,let url = URL(string: stringUrl) else { return }
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                DispatchQueue.main.sync {
                    self.imageViewNew.image = image
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
