//
//  ViewController.swift
//  MOGMOG
//
//  Created by 石丸剣心 on 2022/08/30.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import WebKit



class ViewController: UIViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,DoneCatchDataProtocol {
    
    
    @IBOutlet weak var tenpoSearchBar: UISearchBar!
    
    @IBOutlet weak var tenpoTableView: UITableView!
    
    var tenpoArray = [DataSets]()
    var userName = String()
    var db = Firestore.firestore()
    var userID = String()
    var webView: WKWebView!
    var detail_urlString: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tenpoSearchBar.delegate = self
        tenpoTableView.delegate = self
        tenpoTableView.dataSource = self
        
        tenpoTableView.flashScrollIndicators()
        
        tenpoTableView.register(UINib(nibName: "TenpoCell", bundle: nil), forCellReuseIdentifier: "tenpocell")
        
        tenpoSearchBar.placeholder = "店舗名を入力してください"
        
    }
    
    // サーチボタンを押したときに呼び出されるメソッド
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if tenpoSearchBar.text == "" {
            view.endEditing(true)
            return
            
        } else if tenpoSearchBar.text != nil {
            
            let urlHotpepper_API = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=f6316967937072a9&keyword=\(tenpoSearchBar.text!)&order=4&count=30&format=json"
            
            let searchModel = SearchAndLoad(urlString: urlHotpepper_API)
            searchModel.doneCatchDataProtocol = self
            searchModel.search()

            
            view.endEditing(true)
            
        } else {
            view.endEditing(true)
            return
        }
        
    }
    
    // 関係ないところを押すとキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tenpoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // カスタムセルの中身
        let cell = tableView.dequeueReusableCell(withIdentifier: "tenpocell") as! TenpoCell
        
        cell.TenpoImageView.sd_setImage(with: URL(string: tenpoArray[indexPath.row].ShopPhoto!),completed: nil)
        cell.TenpoNameLabel.text = tenpoArray[indexPath.row].ShopName
        cell.CategoryLabel.text = tenpoArray[indexPath.row].ShopCategory
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alertController = UIAlertController(title: "確認", message: "選択してください", preferredStyle: .actionSheet)
        
        let addMyTenpoAction = UIAlertAction(title: "My店舗に追加", style: .default) {(action) in
            
            if Auth.auth().currentUser?.uid != nil {
                // ログインしていた場合の処理
                // データベースに店舗の情報を送る
                
                let sendDB = sendDB(userName: self.userName,
                                    tenpoImage: self.tenpoArray[indexPath.row].ShopPhoto!,
                                    tenpoName: self.tenpoArray[indexPath.row].ShopName!,
                                    tenpoCategory: self.tenpoArray[indexPath.row].ShopCategory!)
                
                sendDB.sendData(userName: self.userName)
                
                
                if let controller = self.tabBarController?.viewControllers as? MyTenpoViewController {
                    
                    controller.loadViewIfNeeded()
                    controller.MytenpoArray = self.tenpoArray
                }

                
            } else {
                //ログインしてなかった場合の処理
                // アラートを出して未ログインであることを伝える
                let alertController = UIAlertController(title: "エラー", message: "お気に入り機能を利用される場合はログインしてください('プロフィール'より行えます)", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
            

            
        }
        
        alertController.addAction(addMyTenpoAction)
        
        
        let viewDetailAction = UIAlertAction(title: "店舗詳細", style: .default, handler: {(action) in
            // DetailViewControllerに値を渡し遷移する
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailVC = storyboard.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController
            var urlstring = String(self.tenpoArray[indexPath.row].ShopName!)
            
            // urlstringに入っている店舗名をパーセントエンコードしてurlに組み込む
            var encodeString = urlstring.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
            
            detailVC.searchString = "https://www.google.co.jp/search?q=\(encodeString!)"
            
            self.present(detailVC, animated: true)
                
        })
        alertController.addAction(viewDetailAction)
            
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
            //ipadで落ちてしまう対策
            alertController.popoverPresentationController?.sourceView = view
            
            present(alertController, animated: true, completion: nil)
        
    }
    
    func doneCatchData(array: [DataSets]) {
        
        tenpoArray = array
        tenpoTableView.reloadData()
        
    }

    
    func Add_PopupView() {
        
        
        
    }
    

}

