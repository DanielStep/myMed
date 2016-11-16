//
//  Model.swift
//  myMed
//
//  Created by Daniel Stepanenko on 17/04/2016.
//  Code adapted from Rodney Cocker, RMIT
//

import Foundation

class Model{

    // Implementation of Singleton pattern, Model only accessible by Model.sharedInstance
    fileprivate struct Static{
        static var instance: Model?
    }
    
    class var sharedInstance: Model{
        
        if !(Static.instance != nil){
            Static.instance = Model()
        }
        return Static.instance!
    }
    
    var arrayOfDoseProfiles: Array<DoseProfile>?
    var arrayOfMeds: Array<Medication>?
    var personalDetails: UserDetails?
    
    fileprivate init(){
        self.arrayOfDoseProfiles = [DoseProfile]()
        self.arrayOfMeds = [Medication]()
        self.personalDetails = UserDetails()
    }

}
