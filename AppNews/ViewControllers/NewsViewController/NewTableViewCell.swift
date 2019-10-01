//
//  NewTableViewCell.swift
//  AppNews
//
//  Created by Максим Лисица on 26/09/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import UIKit

class NewTableViewCell: UITableViewCell {
    
    weak var delegate: NewsTableViewCellDelegate?
    
    @IBOutlet weak var imageViewNew: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addFavoriteButton: UIButton!
    
    var indexNew: IndexPath?
    var imageStringUrl: String?
    var isOffline: Bool = false
    var imageNew: UIImage? {
        didSet {
            self.imageViewNew.image = self.imageNew
            self.imageActivityIndicator.stopAnimating()
            self.imageActivityIndicator.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.addFavoriteButton.setImage(#imageLiteral(resourceName: "add_to_favorites"), for: .normal)
        self.imageViewNew.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageActivityIndicator.isHidden = false
        self.imageActivityIndicator.startAnimating()
        self.imageViewNew.contentMode = .scaleAspectFill
        setIconButton()
    }
    
    func setIconButton() {
        if isOffline {
            addFavoriteButton.setImage(#imageLiteral(resourceName: "remove_to_favorites"), for: .normal)
        } else {
            addFavoriteButton.setImage(#imageLiteral(resourceName: "add_to_favorites"), for: .normal)
        }
    }
    
    @IBAction func addFavoriteButtonAction(_ sender: UIButton) {
        delegate?.didPressToSaveNew(indexNew: indexNew ?? IndexPath(row: 0, section: 0), button: addFavoriteButton, isOffline: isOffline)
    }
}
