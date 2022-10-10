//
//  SearchAndLoad.swift
//  MOGMOG
//
//  Created by 石丸剣心 on 2022/09/10.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SwiftyJSON
import Alamofire
import SDWebImage


protocol DoneLoadDataProtocol {
    
    func doneLoadData(array: [DataSets])
}

protocol DoneLoadUserNameProtocol {
    
    func doneLoadUserName(array: [String])
}

protocol DoneCatchDataProtocol {
    
    func doneCatchData(array: [DataSets])
}

protocol DoneLoadProfileProtocol {
    
    func doneLoadProfileProtocol(check: Int, imageURLString: String)
    
}

class SearchAndLoad {
    
    var dataSetsArray = [DataSets]()
    var urlString = String()
    var resultParPage = Int()
    
    var db = Firestore.firestore()
    var userNameArray = [String]()
    
    var doneCatchDataProtocol: DoneCatchDataProtocol?
    var doneLoadDataProtocol: DoneLoadDataProtocol?
    var doneLoadUserNameProtocol: DoneLoadUserNameProtocol?
    var doneLoadProfileProtocol: DoneLoadProfileProtocol?
    
    // イニシャライザ
    init(urlString: String) {
        
        self.urlString = urlString
        
    }
    
    init() {
        
    }
    
    
    func search() {
        
        let encodeUrlString = self.urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        print(urlString)
        
        AF.request(encodeUrlString!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            
            print(response)
            
            switch response.result {
                
            case .success:
                do {
                    let json: JSON = try JSON(data: response.data!)
                    print(json.debugDescription)
                    
                    var totalHitcount = json["results"]["results_returned"].string
                    var hitcount = Int(totalHitcount!)
                        
                        
                    self.resultParPage = hitcount!
                    
                    if self.resultParPage >= 1 {
                        
                        for i in 0...self.resultParPage - 1 {
                            
                            if let shopName = json["results"]["shop"][i]["name"].string,
                               let shopCategory = json["results"]["shop"][i]["genre"]["name"].string,
                               let shopPhoto = json["results"]["shop"][i]["photo"]["mobile"]["l"].string {
                                
                                
                                let dataSets = DataSets(ShopName: shopName, ShopCategory: shopCategory, ShopPhoto: shopPhoto)
                                
                                print(dataSets)
                                
                                if shopName.contains("Error 404") == true || shopName.contains("Error 404") == true || shopPhoto.contains("Error 404") {
                                    
                                    
                                }else {
                                    
                                    self.dataSetsArray.append(dataSets)
                                }
                                
                            }
                            
                            
                        } // for i in
                        
                    } else {
                        // resultParPageの中身が1より少なかった場合
                        
                        return
                        
                    }
                    
                    self.doneCatchDataProtocol?.doneCatchData(array: self.dataSetsArray)
                    
                } catch {
                    
                    
                    
                }
            case .failure(_):
                break
            }
            
        }
        
    }
    
    func loadMyTenpoData() {
        
        let uid = Auth.auth().currentUser?.uid
        
        db.collection("Users").document(uid!).collection("collection").order(by: "postDate").addSnapshotListener { (snapShot, error) in
            
            self.dataSetsArray = []
            
            if error != nil {
                
                print(error.debugDescription)
                return
                
            }
            
            if let snapShotDoc = snapShot?.documents {
                
                for doc in snapShotDoc{
                    
                    let data = doc.data()
                    print(data.debugDescription)
                    if let tenpoImage = data["tenpoImage"] as? String,let tenpoName = data["tenpoName"] as? String,let tenpoCategory = data["tenpoCategory"] as? String {
                        
                        let dataSets = DataSets(ShopName: tenpoName, ShopCategory: tenpoCategory, ShopPhoto: tenpoImage)
                        self.dataSetsArray.append(dataSets)
                        
                    }
                }
                
                self.doneLoadDataProtocol?.doneLoadData(array: self.dataSetsArray)
                
            }
            
        }
        
        
    }
    
    func loadProfile() {
        
        let uid = Auth.auth().currentUser?.uid
        
        db.collection("Users").document(uid!).addSnapshotListener { (snapShot,error) in
            
            if error != nil {
                
                print(error.debugDescription)
                return
            }
            
            let data = snapShot?.data()
            
            if let imageURLString = data!["imageURLString"] as? String {
                
                self.doneLoadProfileProtocol?.doneLoadProfileProtocol(check: 1, imageURLString: imageURLString)
                
            }
            
        }
        
    }
    
}
