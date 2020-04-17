//
//  CartTableViewCell.swift
//  GradutionThesis
//
//  Created by Buğra Tunçer on 14.04.2020.
//  Copyright © 2020 Buğra Tunçer. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    @IBOutlet weak var nameFood: UILabel!
    @IBOutlet weak var plateCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
