//
//  PassChangeViewController.swift
//  MOGMOG
//
//  Created by 石丸剣心 on 2022/10/10.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PassChangeViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var mailTextField: UITextField!
    
    @IBOutlet weak var passChangeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mailTextField.delegate = self
        AddShadow_Buttons()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func PassChangeButton(_ sender: Any) {
        
        Send_PassResetMail()
        
    }
    
    
    
    func Send_PassResetMail() {
        
        let email = mailTextField.text!
        
        Auth.auth().sendPasswordReset(withEmail: email) {(error) in
            // エラー処理
            if error != nil {
                print(error.debugDescription)
                let alert = UIAlertController(title: "エラー", message: "メールを送れませんでした。もう一度メールアドレスをご確認ください。", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default)
                
                alert.addAction(defaultAction)
                self.present(alert, animated: true)
                
                return
            }
            // 再設定メールを送信できたことをアラートで出す
            let alert = UIAlertController(title: "通知", message: "再設定メールを送信しました。送信されたメールから再設定を行ってください", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default) {(action) in
                
                self.navigationController?.popViewController(animated: true)
            }
            
            alert.addAction(defaultAction)
            self.present(alert, animated: true)
            
            
        }
        
    }
    
    
    func AddShadow_Buttons() {
        
        passChangeButton.layer.cornerRadius = 10
        
        // 影の濃さ
        passChangeButton.layer.shadowOpacity = 0.5
        
        // 影のぼかしの大きさ
        passChangeButton.layer.shadowRadius = 3
        
        // 影の色
        passChangeButton.layer.shadowColor = UIColor.black.cgColor

        // 影の方向
        passChangeButton.layer.shadowOffset = CGSize(width: 5, height: 5)

        
    }
    
    
    
    
    

}
