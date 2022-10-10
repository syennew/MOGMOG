//
//  UserData.swift
//  MOGMOG
//
//  Created by 石丸剣心 on 2022/10/02.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct UserData {
    
    var name = String()
    var createdAt = Timestamp()
    var email = String()
    
    init(dic: [String: Any]){
        
        self.name = dic["name"] as! String
        self.createdAt = dic["createdAt"] as! Timestamp
        self.email = dic["email"] as! String
        
    }
    
    init() {
        
        
    }
    
}
