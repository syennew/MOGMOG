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

class SearchAndLoad {
    
    var dataSetsArray = [DataSets]()
    var urlString = String()
    var resultParPage = Int()
    
    // イニシャライザ
    init(urlString: String) {
        
        self.urlString = urlString
        
    }
    
    init() {
        
    }
    
    
    func search() {
        
        let encodeUrlString = self.urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        AF.request(encodeUrlString as! URLConvertible, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            
            
            switch response.result {
            
            case .success:
                do {
                    let json: JSON = try JSON(data: response.data!)
                    print(json.debugDescription)
                    
                    let totalHitcount = json["pageInfo"]["resultsPerPage"].int
                    
                    if totalHitcount! < 50 {
                        
                        self.resultParPage = totalHitcount!
                        
                    }else {
                        
                        self.resultParPage = totalHitcount!
                        
                    }
                    
                    for i in 0...self.resultParPage - 1 {
                        
                        if let title = json["items"][i]["snippet"]["title"].string,
                           let description = json["items"][i]["snippet"]["description"].string,
                           let url = json["items"][i]["snippet"]["thumbnails"]["default"]["url"].string,
                           let channelId = json["items"][i]["snippet"]["channelId"].string {
                            
                            if json["items"][i]["id"]["channelId"].string == channelId {
                                
                            }else {
                            
                            
                            let dataSets = DataSets(aaa)
                            
                            if title.contains("Error 404") == true || description.contains("Error 404") == true || url.contains("Error 404") {
                            
                            
                            }else {
                                
                                self.dataSetsArray.append(dataSets)
                                
                            }
                        
                            }
                            
                        }
                    
                    } // for i in
                    
                    self.delegate?.donecatchdata(array: self.dataSetsArray)
            
                } catch {
                    
                    
                    
                }
            case .failure(_):
                break
            }
        
    }
    
}
    
}
