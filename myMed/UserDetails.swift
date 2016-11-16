//
//  UserDetails.swift
//  myMed
//
//  Created by Luke McCartin on 17/04/2016.
//

import Foundation

class UserDetails {
    
    var userGiveName: String?
    var userSurName: String?
    var userAllergy: String?
    var emergGiveName: String?
    var emergSurName: String?
    var emergContactNo: String?
    var docName: String?
    var docContactNo: String?
    var docAddress: String?
    
    init () {
        self.userGiveName = ""
        self.userSurName = ""
        self.userAllergy = ""
        self.emergGiveName = ""
        self.emergSurName = ""
        self.emergContactNo = ""
        self.docName = ""
        self.docContactNo = ""
        self.docAddress = ""
    }
    
    init(giveName: String, surName: String, allergy: String, emergGiveName: String, emergSurName: String, emergContactNo: String, docName: String, docContactNo: String, docAddress: String) {
        
        self.userGiveName = giveName
        self.userSurName = surName
        self.userAllergy = allergy
        self.emergGiveName = emergGiveName
        self.emergSurName = emergSurName
        self.emergContactNo = emergContactNo
        self.docName = docName
        self.docContactNo = docContactNo
        self.docAddress = docAddress
    }
}
