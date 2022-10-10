//
//  LoginViewController.swift
//  MOGMOG
//
//  Created by 石丸剣心 on 2022/09/29.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore



class RegisterViewController: UIViewController {
    
    var userName = String()
    
    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AddShadow_Buttons()
        
        mailTextField.delegate = self
        passwordTextField.delegate = self
        userNameTextField.delegate = self
        // キーボードを表示する
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // キーボードを閉じる
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    
    @objc func showKeyboard(notification: Notification) {
        print("showKeyboard is showing")
        
        // キーボードを表示するとき、キーボードの一番上とログインボタンの一番下の距離の差分だけキーボードを上げる
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        
        guard let keyboardMinY = keyboardFrame?.minY else { return }
        let loginButtonMaxY = registerButton.frame.maxY
        let distance = loginButtonMaxY - keyboardMinY + 20
        
        let transform = CGAffineTransform(translationX: 0, y: -distance)
        
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
    
    
    @IBAction func RegisterButton(_ sender: Any) {
        
        handleAuthToFirebase()
        
    }
    
    
    
    func handleAuthToFirebase() {
        guard let email = mailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (response, error) in
            if let error = error {
                print("認証情報の保存に失敗しました。\(error)")
                return
                
            }
            self.addUserInfoToFirestore(email: email)
            let alert = UIAlertController(title: "報告", message: "ユーザー登録が完了しました'My店舗登録機能'が使えます", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default) {(action) in
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let profileVC = storyboard.instantiateViewController(withIdentifier: "profileVC") as! ProfileViewController
                self.navigationController?.pushViewController(profileVC, animated: true)
                
            }
            alert.addAction(defaultAction)
            self.present(alert, animated: true,completion: nil)
            
            print("認証情報の保存に成功しました")
            
        }

        
    }// func handleAuthToFirebase()
    
    func addUserInfoToFirestore(email: String) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let name = self.userNameTextField.text else { return }
        
        let docData = ["email": email, "name": name, "createdAt": Timestamp()] as [String: Any]
        let userRef = Firestore.firestore().collection("Users").document(uid)
        
        Firestore.firestore().collection("Users").document(uid).setData(docData) { (error) in
            
            userRef.setData(docData) { (error) in
                if let error = error {
                    print("firestoreへの保存に失敗しました。\(error)")
                    return
                    
                }
                
                print("firestoreへの保存に成功しました")
                
                userRef.getDocument { (snapshot, error) in
                    if let error = error {
                        
                        print("ユーザー情報の取得に失敗しました。\(error)")
                        return
                        
                    }
                    
                    guard let data = snapshot?.data() else { return }
                    let user = UserData.init(dic: data)
                    print("ユーザー情報の取得に成功しました。\(user.name)")
                    
                }
                
                
            }

            
        }
        
        
    }
    
    // ボタンに影を追加するメソッド
    func AddShadow_Buttons() {
        
        registerButton.layer.cornerRadius = 10
        
        // 影の濃さ
        registerButton.layer.shadowOpacity = 0.5
        
        // 影のぼかしの大きさ
        registerButton.layer.shadowRadius = 3
        
        // 影の色
        registerButton.layer.shadowColor = UIColor.black.cgColor
        
        // 影の方向
        registerButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        
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

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        let emailIsEmpty = mailTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        let userNameIsEmpty = userNameTextField.text?.isEmpty ?? true
        
        if emailIsEmpty || passwordIsEmpty || userNameIsEmpty {
            registerButton.isEnabled = false
            registerButton.backgroundColor = UIColor.rgb(red: 200, green: 200, blue: 85)
        } else {
            registerButton.isEnabled = true
            registerButton.backgroundColor = UIColor.rgb(red: 255, green: 200, blue: 85)
        }
        print("textField.text", textField.text!)
    }
}
