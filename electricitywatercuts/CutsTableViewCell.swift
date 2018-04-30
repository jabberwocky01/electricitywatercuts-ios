//
//  CutsTableViewCell.swift
//  electricitywatercuts
//
//  Created by nils on 28.04.2018.
//  Copyright © 2018 nils. All rights reserved.
//

import UIKit

class CutsTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var cutImage: UIImageView!
    @IBOutlet weak var operatorInfo: UILabel!
    @IBOutlet weak var durationInfo: UILabel!
    @IBOutlet weak var detailedInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
