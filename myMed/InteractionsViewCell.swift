//
//  InteractionsViewCell.swift
//  myMed
//
//  Created by Luke McCartin on 30/04/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import UIKit

class InteractionsViewCell: UITableViewCell {
    
    
    @IBOutlet weak var medicationNamelbl : UILabel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
