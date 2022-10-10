//
//  NameChangeViewController.swift
//  MOGMOG
//
//  Created by 石丸剣心 on 2022/10/06.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class NameChangeViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var Reset_userNameButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userNameTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func Reset_userNameButton(_ sender: Any) {
        
        let uid = Auth.auth().currentUser?.uid
        let docData = Firestore.firestore().collection("Users").document(uid!)
        
        docData.updateData(["name": self.userNameTextField.text!]) { error in
            
            if let error = error {
                
                print("失敗しました")
                let alert = UIAlertController(title: "エラー", message: "ユーザーネームの変更に失敗しました", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default)
                
                alert.addAction(defaultAction)
                self.present(alert, animated: true)
                
                self.userNameTextField.text = ""
                
            } else {
                
                print("成功しました")
                let alert = UIAlertController(title: "通知", message: "ユーザーネームの変更に成功しました。", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default)
                
                alert.addAction(defaultAction)
                self.present(alert, animated: true)
                
                self.userNameTextField.text = ""
                
            }
            
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
