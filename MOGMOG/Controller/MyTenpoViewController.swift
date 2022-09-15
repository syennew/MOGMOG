//
//  MyTenpoViewController.swift
//  MOGMOG
//
//  Created by 石丸剣心 on 2022/08/30.
//

import UIKit

class MyTenpoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    
    
    @IBOutlet weak var searchMyTenpo: UISearchBar!
    
    @IBOutlet weak var tableView_MyTenpo: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchMyTenpo.delegate = self
        tableView_MyTenpo.delegate = self
        tableView_MyTenpo.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
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
