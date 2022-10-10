//
//  DetailViewController.swift
//  MOGMOG
//
//  Created by 石丸剣心 on 2022/10/04.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var searchString = String()
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView = WKWebView(frame: self.view.frame)
        view.addSubview(webView)
        
        let request = URLRequest(url: URL(string: searchString)!)
        
        self.webView.load(request)

        // Do any additional setup after loading the view.
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
