//
//  MyTenpoViewController.swift
//  MOGMOG
//
//  Created by 石丸剣心 on 2022/08/30.
//

import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseFirestore
import ViewAnimator


protocol MyTenpoDataProtocol {
    
    func sendValue()
}

class MyTenpoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,DoneLoadDataProtocol {
    
    var userName = String()
    var MytenpoArray = [DataSets]()
    var userNameArray = [String]()
    var searchAndLoad = SearchAndLoad()
    
    var tenpoName = String()
    
    @IBOutlet weak var tableView_MyTenpo: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView_MyTenpo.delegate = self
        tableView_MyTenpo.dataSource = self
        
        tableView_MyTenpo.flashScrollIndicators()
        
        tableView_MyTenpo.register(UINib(nibName: "TenpoCell", bundle: nil), forCellReuseIdentifier: "tenpocell")
        
        searchAndLoad.doneLoadDataProtocol = self
        
        if Auth.auth().currentUser?.uid != nil{
            self.searchAndLoad.loadMyTenpoData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let animation = AnimationType.from(direction: .top, offset: 50)
        UIView.animate(views: tableView_MyTenpo.visibleCells, animations: [animation], delay: 0, duration: 1)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MytenpoArray.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView_MyTenpo.dequeueReusableCell(withIdentifier: "tenpocell", for: indexPath) as! TenpoCell
        
        cell.TenpoNameLabel.text = MytenpoArray[indexPath.row].ShopName
        cell.TenpoImageView.sd_setImage(with: URL(string: MytenpoArray[indexPath.row].ShopPhoto!), completed: nil)
        cell.CategoryLabel.text = MytenpoArray[indexPath.row].ShopCategory
        
        tenpoName = cell.TenpoNameLabel.text!
        
        let animation = AnimationType.from(direction: .bottom, offset: 50)
        UIView.animate(views: tableView_MyTenpo.visibleCells, animations: [animation], duration: 0.2)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alertController = UIAlertController(title: "確認", message: "選択してください", preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: "シェアする", style: .default) {(action) in
            // MytenpoArrayの中にある店舗名をパーセントエンコードしてURLに組み込む
            let searchString = String(self.MytenpoArray[indexPath.row].ShopName!)
            let encodeString = searchString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
            let url = "https://www.google.co.jp/search?q=\(encodeString!)"
            let url_tmp = URL(string: url)
            let urlArray = [url_tmp]
            
            let activityViewController = UIActivityViewController(activityItems: urlArray, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            self.present(activityViewController, animated: true)
            
        }
        
        alertController.addAction(shareAction)
        
        
        let viewDetailAction = UIAlertAction(title: "店舗詳細", style: .default, handler: {(action) in
            // DetailViewControllerに値を渡し遷移する
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailVC = storyboard.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController
            var urlstring = String(self.MytenpoArray[indexPath.row].ShopName!)
            
            // urlstringに入っている店舗名をパーセントエンコードしてurlに組み込む
            var encodeString = urlstring.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
            
            detailVC.searchString = "https://www.google.co.jp/search?q=\(encodeString!)"
            
            self.present(detailVC, animated: true)
            
        })
        alertController.addAction(viewDetailAction)
        
        let deleteAction = UIAlertAction(title: "My店舗から削除", style: .default, handler: {(action) in
            
            let uid = Auth.auth().currentUser?.uid
            Firestore.firestore().collection("Users").document(uid!).collection("collection").document(self.tenpoName).delete() {error in
                
                if let error = error {
                    
                    print("データの削除に失敗しました")
                } else {
                    print("データの削除に成功しました")
                    
                    let alert = UIAlertController(title: "通知", message: "削除しました", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default)
                    
                    alert.addAction(defaultAction)
                    self.present(alert, animated: true)
                    
                    self.tableView_MyTenpo.reloadData()
                    
                }
                
            }
            
        })
        alertController.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        //ipadで落ちてしまう対策
        alertController.popoverPresentationController?.sourceView = view
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func doneLoadData(array: [DataSets]) {
        
        MytenpoArray = array
        tableView_MyTenpo.reloadData()
        
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
