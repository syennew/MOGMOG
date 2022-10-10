//
//  UIColor-Extension.swift
//  MOGMOG
//
//  Created by 石丸剣心 on 2022/09/29.
//

import Foundation
import UIKit

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        
        return self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    
}
