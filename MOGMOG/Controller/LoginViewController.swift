//
//  LoginViewController.swift
//  MOGMOG
//
//  Created by 石丸剣心 on 2022/10/02.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var go_registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AddShadow_Buttons()
        
        mailTextField.delegate = self
        passwordTextField.delegate = self
        
        // キーボードを表示する
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // キーボードを閉じる
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func LoginButton(_ sender: Any) {
        
        guard let email = mailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (response, error) in
            
            if let error = error {
                print("ログイン情報の取得に失敗しました。\(error)")
                
                let alert = UIAlertController(title: "エラー", message: "ログインできません。メールアドレス又はパスワードをもう一度ご確認ください。", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default)
                
                alert.addAction(defaultAction)
                self.present(alert, animated: true)
                
                return
                
            }
            print("ログインに成功しました")
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let userRef = Firestore.firestore().collection("Users").document(uid)
            
            userRef.getDocument { (snapshot, error) in
                if let error = error {
                    
                    print("ユーザー情報の取得に失敗しました。\(error)")
                    return
                    
                }
                
                guard let data = snapshot?.data() else { return }
                let user = UserData.init(dic: data)
                
                
            }
            
            let alert = UIAlertController(title: "報告", message: "ログインしました'My店舗登録機能'が使えます", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default) {(action) in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let profileVC = storyboard.instantiateViewController(withIdentifier: "profileVC") as! ProfileViewController
                self.navigationController?.pushViewController(profileVC, animated: true)
                
            }
            alert.addAction(defaultAction)
            self.present(alert, animated: true,completion: nil)
        }
    }
        
        @IBAction func Go_RegisterButton(_ sender: Any) {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let registerVC = storyboard.instantiateViewController(withIdentifier: "registerVC") as! RegisterViewController
            self.navigationController?.pushViewController(registerVC, animated: true)
            
        }
    
    
    @IBAction func Reset_PasswordButton(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let passChangeVC = storyboard.instantiateViewController(withIdentifier: "passChangeVC") as! PassChangeViewController
        self.navigationController?.pushViewController(passChangeVC, animated: true)
        
    }
    
    
        
        
        @objc func showKeyboard(notification: Notification) {
            print("showKeyboard is showing")
            
            // キーボードを表示するとき、キーボードの一番上とログインボタンの一番下の距離の差分だけviewを上げる
            let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            
            guard let keyboardMinY = keyboardFrame?.minY else { return }
            let loginButtonMaxY = loginButton.frame.maxY
            let distance = loginButtonMaxY - keyboardMinY + 180
            
            let transform = CGAffineTransform(translationX: 0, y: distance)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1,initialSpringVelocity: 1,options: [], animations: {
                self.view.transform = transform
            })
        }
        
        @objc func hideKeyboard() {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1,initialSpringVelocity: 1,options: [], animations: {
                self.view.transform = .identity
            })
            print("hideKeyboard is hiding")
            
        }
        
        // 関係ないところを押すとキーボードを閉じる
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
        
        // ボタンに影を追加するメソッド
        func AddShadow_Buttons() {
            
            go_registerButton.layer.cornerRadius = 10
            loginButton.layer.cornerRadius = 10
            
            // 影の濃さ
            go_registerButton.layer.shadowOpacity = 0.5
            loginButton.layer.shadowOpacity = 0.5
            
            // 影のぼかしの大きさ
            go_registerButton.layer.shadowRadius = 3
            loginButton.layer.shadowRadius = 3
            
            // 影の色
            go_registerButton.layer.shadowColor = UIColor.black.cgColor
            loginButton.layer.shadowColor = UIColor.black.cgColor
            
            // 影の方向
            go_registerButton.layer.shadowOffset = CGSize(width: 5, height: 5)
            loginButton.layer.shadowOffset = CGSize(width: 5, height: 5)
            
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


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        let emailIsEmpty = mailTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true

        
        if emailIsEmpty || passwordIsEmpty {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 236)
        } else {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 0, green: 255, blue: 236)
        }
        print("textField.text", textField.text!)
    }
}
