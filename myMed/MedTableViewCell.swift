//
//  MedTableViewCell.swift
//  myMed
//
//  Created by Daniel Stepanenko on 30/03/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import UIKit

class MedTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblMedName: UILabel!
    
    @IBOutlet weak var lblAmount: UILabel!

    @IBOutlet weak var imageMed: UIImageView!
    
    @IBOutlet weak var lblDoseTimes: UILabel!
    
    @IBOutlet weak var lblInterval: UILabel!
    
    @IBOutlet weak var infoButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
