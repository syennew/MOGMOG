//
//  sendDB.swift
//  MOGMOG
//
//  Created by 石丸剣心 on 2022/09/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage


protocol DoneSendProfileDelegate {
    
    func doneSendProfile(sendCheck:Int)
    
}

class sendDB {
    
    var donesendprofileDelegate: DoneSendProfileDelegate?
    
    var userName = String()
    var imageData = Data()
    var db = Firestore.firestore()
    
    var userID = String()
    var tenpoImage = String()
    var tenpoName = String()
    var tenpoCategory = String()
    
    
    init() {
        
        
    }
    
    init(userName: String,
         tenpoImage: String,
         tenpoName: String,
         tenpoCategory: String) {
        
        
        self.userName = userName
        self.tenpoImage = tenpoImage
        self.tenpoName = tenpoName
        self.tenpoCategory = tenpoCategory
        
    }
    
    func sendData(userName: String) {
        
        let uid = Auth.auth().currentUser?.uid
        
        self.db.collection("Users").document(uid!).collection("collection").document().setData(
            ["tenpoImage": self.tenpoImage as Any,
             "tenpoName": self.tenpoName as Any,
             "tenpoCategory": tenpoCategory as Any,
             "postDate": Date().timeIntervalSince1970])
        
        
    }
    
    func sendProfile(imageData:Data) {
        
        let imageRef = Storage.storage().reference().child("ProfileImageFolder").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        
        imageRef.putData(imageData, metadata: nil) { (metadata,error) in
            
            if error != nil {
                print(error.debugDescription)
                return
                
            } // エラーの場合ここで処理を中断する
            
            imageRef.downloadURL { (url, error) in
                
                if error != nil {
                    print(error.debugDescription)
                    return
                }
                
                let uid = Auth.auth().currentUser?.uid
                self.db.collection("Users").document(uid!).setData(
                    
                    ["imageURLString":url?.absoluteString as Any]
                    
                )
                
                self.donesendprofileDelegate?.doneSendProfile(sendCheck: 1)
            }
            
        } // クロージャー
        
    }
    
}
