//
//  WebViewController.swift
//  AppNews
//
//  Created by Максим Лисица on 28/09/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var vebViewNew: WKWebView!
    
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: urlString ?? "") else { return }
        let request = URLRequest(url: url)
        self.vebViewNew.load(request)
    }
}
