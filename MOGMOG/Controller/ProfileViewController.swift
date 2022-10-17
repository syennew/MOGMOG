//
//  ProfileViewController.swift
//  MOGMOG
//
//  Created by 石丸剣心 on 2022/08/30.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import Photos

class ProfileViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var db = Firestore.firestore()
    var userData: UserData?
    var profileImage = UIImageView()
    var uid = Auth.auth().currentUser?.uid
    var profileName = String()
    var searchAndLoad = SearchAndLoad()
    
    
    @IBOutlet weak var profileLabel: UILabel!
    
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var loginAndregisterButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AddShadow_Buttons()
        
        if Auth.auth().currentUser?.uid != nil {
            // firestoreから"name"フィールドの値をとってくる
            let profileLabelData = db.collection("Users").document(uid!)
            profileLabelData.getDocument {(doc, error) in
                if let docment = doc, docment.exists {
                    
                    let dataDescription = docment.get("name")
                    print(dataDescription as! String)
                    // profileName変数に"name"フィールド値を格納
                    self.profileName = dataDescription as! String
                    
                    self.profileLabel.text = dataDescription as! String
                    
                } else {
                    print("Docment does not exist")
                    
                }
                
                self.searchAndLoad.loadProfile()
            }
            
        } else {
            
            profileLabel.text = "no name"
        }
        
    
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser?.uid != nil {
            
            let profileLabelData = db.collection("Users").document(uid!)
            
            profileLabelData.getDocument {(doc, error) in
                
                if let docment = doc, docment.exists {
                    
                    let dataDescription = docment.get("name")
                    print(dataDescription as! String)
                    // profileName変数に"name"フィールド値を格納
                    self.profileName = dataDescription as! String
                    
                    self.profileLabel.text = dataDescription as! String
                }
                
                self.searchAndLoad.loadProfile()
                
            }
            
        } else {
            
            self.profileLabel.text = "no name"
            
        }
    }
    
    // ログイン画面に画面遷移するボタン
    @IBAction func loginAndregisterButton(_ sender: Any) {
        
        if Auth.auth().currentUser?.uid != nil {
            
            let alert = UIAlertController(title: "確認", message: "すでにログイン済みです", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
            
        } else {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
            self.navigationController?.pushViewController(loginVC, animated: true)
            
        }
    }
    
    // SettingViewControllerに画面遷移するボタン
    @IBAction func settingButton(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let settingVC = storyboard.instantiateViewController(withIdentifier: "settingVC") as! SettingViewController
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    // ログアウトするボタン
    @IBAction func LogoutButton(_ sender: Any) {
        
        let alertController = UIAlertController(title: "確認", message: "本当にログアウトしますか？", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            do {
                try Auth.auth().signOut()
                
                self.profileLabel.text = "no name"
                
            } catch {
                
                print("ログアウトに失敗しました")
                
            }
            
        }
        alertController.addAction(defaultAction)
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    // ボタンに影を追加するメソッド
    func AddShadow_Buttons() {
        
        loginAndregisterButton.layer.cornerRadius = 10
        settingButton.layer.cornerRadius = 10
        logoutButton.layer.cornerRadius = 10
        
        // 影の濃さ
        loginAndregisterButton.layer.shadowOpacity = 0.5
        settingButton.layer.shadowOpacity = 0.5
        logoutButton.layer.shadowOpacity = 0.5
        
        // 影のぼかしの大きさ
        loginAndregisterButton.layer.shadowRadius = 3
        settingButton.layer.shadowRadius = 3
        logoutButton.layer.shadowRadius = 3
        
        // 影の色
        loginAndregisterButton.layer.shadowColor = UIColor.black.cgColor
        settingButton.layer.shadowColor = UIColor.black.cgColor
        logoutButton.layer.shadowColor = UIColor.black.cgColor
        
        // 影の方向
        loginAndregisterButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        settingButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        logoutButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        
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
