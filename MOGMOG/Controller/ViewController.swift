//
//  ViewController.swift
//  MOGMOG
//
//  Created by 石丸剣心 on 2022/08/30.
//

import UIKit

class ViewController: UIViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var tenpoSearchBar: UISearchBar!
    
    @IBOutlet weak var tenpoTableView: UITableView!
    
    var tenpoArray = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tenpoSearchBar.delegate = self
        tenpoTableView.delegate = self
        tenpoTableView.dataSource = self
        
        tenpoSearchBar.placeholder = "店舗名を入力してください"
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // if文で何もない状態でも検索できるようにデフォルトの値をkeywordに入れる
        let urlHotpepper_API = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=f6316967937072a9&keyword=\(searchBar.text)&order=4&count=30&format=json"

        view.endEditing(true)
        var searchModel = SearchAndLoad()
        searchModel.search()
        
    }
    
    func searchTenpo() {
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    

}

