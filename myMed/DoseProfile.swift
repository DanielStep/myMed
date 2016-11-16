//
//  DoseProfile.swift
//  myMed
//
//  Created by Daniel Stepanenko on 29/03/2016.
//

import Foundation
import EventKit

class DoseProfile{
    
    var doseTimes: Array<Date>?
    var reminderIDArray: Array<String>?
    var dayInterval: Int?
    
    init(doseTimes: Array<Date>, dayInterval: Int){
        
        self.doseTimes = doseTimes
        self.dayInterval = dayInterval
        self.reminderIDArray = [String]()
    }
}
