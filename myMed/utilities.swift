//
//  utilities.swift
//  myMed
//
//  Created by Daniel Stepanenko on 17/04/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import Foundation
import UIKit
import EventKit

//Utility Function converts array of NSDate to string of times
func tokenizeDoseTimeArray(_ dateArray: Array<Date>) ->String?{
    
    var timeStringArray = Array<String>()
    
    for date in dateArray {
        
        let timeString = dateToString(date)
        timeStringArray.append(timeString!)
    }
    
    let timeProfileString = timeStringArray.joined(separator: ", ")
    
    return timeProfileString
    
}

//Utility function converts NSDate to string of particular format
func dateToString(_ time: Date) -> String?{
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h a"
    
    let timeString = dateFormatter.string(from: time)
    
    return timeString
}

func componentsToDate(_ time: DateComponents) -> Date?{
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    dateFormatter.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    
    let dateToDisplay = dateFormatter.calendar.date(from: time)!
    return dateToDisplay
}

//Utility Function converts array of time strings to array of NSDates
func timeStringArrayToDateArray(_ timeStringArray: Array<String>) -> Array<Date>?{
    
    var dateArray = Array<Date>()
    
    for timeString in timeStringArray{
        
        let selectedTime = convertTime(timeString)
        let currentDate = requestCurrentDateComponents()
        let customDate = buildCustomDate(currentDate!, selectedHour: selectedTime!)
        
        dateArray.append(customDate!)
    }
    
    return dateArray
}

//Utility Function converts reminder to it's corresponding ID
func reminderToIdentifier (_ reminder: EKReminder?) ->String?{
    
    let id: String?
    
    if(reminder != nil){
     id = reminder!.calendarItemExternalIdentifier
    } else{
        id = nil
    }
    return id
}

//Utility function fetches reminder based on given ID
func identifierToReminder(_ id: String?) ->EKReminder?{

    var reminder: EKReminder?
    var calItemArray = [EKCalendarItem]()
    
    if(id != nil){
        calItemArray = EventStore.sharedInstance.calendarItems(withExternalIdentifier: id!)
        if(!calItemArray.isEmpty){
            reminder = calItemArray[0] as? EKReminder
        }
    }
    return reminder
}




