//
//  UD_UserJoinTableViewCell.swift
//  UnoDealer
//
//  Created by mac on 1/19/17.
//  Copyright © 2017 VietAnh. All rights reserved.
//

import UIKit

class UD_UserJoinTableViewCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var amount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
