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

        // Do any additional setup after loading the view.
        guard let url = URL(string: urlString ?? "") else { return }
        let request = URLRequest(url: url)
        
        vebViewNew.load(request)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
