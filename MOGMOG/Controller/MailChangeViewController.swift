//
//  MailChangeViewController.swift
//  MOGMOG
//
//  Created by 石丸剣心 on 2022/10/06.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class MailChangeViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    
    @IBOutlet weak var mailSetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mailTextField.delegate = self
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func MailSetButton(_ sender: Any) {
        
        let email = Auth.auth().currentUser?.email
        let password = passwordTextField.text!
        
        Auth.auth().signIn(withEmail: email!, password: password)
        
        if Auth.auth().currentUser?.email != mailTextField.text {
        
            Auth.auth().currentUser?.updateEmail(to: mailTextField.text!) { error in
                if let error = error {
                    print(error)
                    
                    let alert = UIAlertController(title: "エラー", message: "メールアドレスの変更に失敗しました。パスワードが違う、もしくは有効なメールアドレスではありません。もう一度ご確認ください。", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default)
                    
                    alert.addAction(defaultAction)
                    self.present(alert, animated: true)
                    
                    self.mailTextField.text = ""
                    self.passwordTextField.text = ""
                    
                    return
                    
                } else {
                    
                    let alert = UIAlertController(title: "通知", message: "メールアドレスが変更されました", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default)
                    
                    alert.addAction(defaultAction)
                    self.present(alert, animated: true)
                    
                    self.mailTextField.text = ""
                    self.passwordTextField.text = ""
                    
                }
                
            }
            
            
        } else {
            
            let alert = UIAlertController(title: "エラー", message: "メールアドレスが同じです。違うメールアドレスを入力してください。", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default)
            
            alert.addAction(defaultAction)
            self.present(alert, animated: true)
            
            mailTextField.text = ""
            
        }
        
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
