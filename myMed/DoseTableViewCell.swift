//
//  DoseTableViewCell.swift
//  myMed
//
//  Created by Daniel Stepanenko on 5/04/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import UIKit

class DoseTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var doseTimes: UILabel!
    @IBOutlet weak var doseInterval: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
