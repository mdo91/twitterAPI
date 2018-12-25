//
//  TableViewCell.swift
//  TwitterApp
//
//  Created by ASP on 12/17/18.
//  Copyright © 2018 ASP. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

   
    
    @IBOutlet weak var longText: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var usrname: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
