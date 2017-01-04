//
//  UD_RoomTableViewCell.swift
//  UnoDealer
//
//  Created by mac on 1/4/17.
//  Copyright © 2017 VietAnh. All rights reserved.
//

import UIKit

class UD_RoomTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
