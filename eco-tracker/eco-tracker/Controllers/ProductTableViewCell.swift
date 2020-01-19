//
//  ProductTableViewCell.swift
//  eco-tracker
//
//  Created by Benjamin Searle on 19/01/2020.
//  Copyright © 2020 Benjamin Searle. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    
    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
