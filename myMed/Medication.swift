//
//  Medication.swift
//  myMed
//
//  Created by Daniel Stepanenko on 29/03/2016.
//

import Foundation
import UIKit

class Medication {
    
    var medName: String?
    var medDosage: String?
    var doseProfile: DoseProfile?
    var medImage: UIImage?
    
    
    init (medName: String, medDosage: String, doseProfile: DoseProfile?){
        
        self.medName = medName;
        self.medDosage = medDosage;
        self.doseProfile = doseProfile;
    }
    init (medName: String, medDosage: String){
        
        self.medName = medName;
        self.medDosage = medDosage;
    }
    init (medName: String, medDosage: String, doseProfile: DoseProfile?, medImage: UIImage){
        
        self.medName = medName;
        self.medDosage = medDosage;
        self.doseProfile = doseProfile;
        self.medImage = medImage;
    }
    init (medName: String, medDosage: String, medImage: UIImage){
        
        self.medImage = medImage
        self.medName = medName;
        self.medDosage = medDosage;
    }


}
