//
//  NameTableViewCell.swift
//  ChainChatiOS
//
//  Created by Jeremy Francispillai on 2014-09-20.
//  Copyright (c) 2014 Jeremy Francispillai. All rights reserved.
//

import UIKit

class NameTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
