//
//  TenpoCell.swift
//  MOGMOG
//
//  Created by 石丸剣心 on 2022/09/22.
//

import UIKit
import SDWebImage


class TenpoCell: UITableViewCell {
    
    
    @IBOutlet weak var TenpoImageView: UIImageView!
    
    @IBOutlet weak var CategoryLabel: UILabel!
    
    @IBOutlet weak var TenpoNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

        // Configure the view for the selected state
    }
    
    
}
