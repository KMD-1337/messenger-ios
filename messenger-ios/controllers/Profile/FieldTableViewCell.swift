//
//  FieldTableViewCell.swift
//  messenger-ios
//
//  Created by Dima on 11.01.2021.
//

import UIKit

class FieldTableViewCell: UITableViewCell {

    @IBOutlet var textField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
