//
//  EventStore.swift
//  myMed
//
//  Created by Daniel Stepanenko on 18/04/2016.
//

import Foundation
import EventKit
import EventKitUI


class EventStore {
    
    fileprivate struct Static{
        static var instance: EKEventStore?
    }
    
    class var sharedInstance: EKEventStore{
        
        if !(Static.instance != nil){
            Static.instance = EKEventStore()
        }
        return Static.instance!
    }
    
    fileprivate init(){
        
    }


    
}






