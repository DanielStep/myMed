//
//  DateCreation.swift
//  myMed
//
//  Created by Daniel Stepanenko on 16/04/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import Foundation

// Utility Function for converting NSDate to NSDateComponents
func dateToComponents(_ date: Date) -> DateComponents{
    
    let userCalendar = Calendar.current;
    let requestedDateComponents: NSCalendar.Unit = [.year,
        .month,
        .day,
        .hour,
        .minute,
        .second,
        .weekday]
    
    let dateComponents = (userCalendar as NSCalendar).components(requestedDateComponents, from: date)
    return dateComponents
}

// Utility Function gets the current date and outputs it as components year, month and day
func requestCurrentDateComponents() ->RequestedComponents?{
    
    let userCalendar = Calendar.current;
    let requestedDateComponents: NSCalendar.Unit = [.year,.month,.day,.weekday]
    
    //Requesting components from current live date
    
    let now = Date()
    let userCalComponents = (userCalendar as NSCalendar).components(requestedDateComponents, from: now)
    
    //Freeze requested date components as Int
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "yyyy"
    let yearAsInt = Int(dateFormatter.string(from: now))!
    dateFormatter.dateFormat = "MM"
    let monthAsInt = Int(dateFormatter.string(from: now))!
    dateFormatter.dateFormat = "dd"
    let dayAsInt = Int(dateFormatter.string(from: now))!
    let weekDayAsInt = userCalComponents.weekday
    
    //Aggregate into store struct
    let requestedComponents = RequestedComponents(year: yearAsInt, month: monthAsInt, day: dayAsInt, weekday: weekDayAsInt!)
    
    return requestedComponents
}

// Utility Function builds custom date from current date components
func buildCustomDate(_ reqComponents: RequestedComponents, selectedHour: Int) ->Date?{
    
    let userCalendar = Calendar.current;
    var newComponents = DateComponents()
    
    //Year, Month, Day, Weekday from requested components of current date
    newComponents.year = reqComponents.year
    newComponents.month = reqComponents.month
    newComponents.day = reqComponents.day
    newComponents.weekday = reqComponents.weekday
    
    //Hour is selected value from Dose time Picker
    newComponents.hour = selectedHour
    newComponents.minute = 00
    newComponents.second = 0
    
    //Create date from components
    let newDate = userCalendar.date(from: newComponents)
    
    return newDate
}

//Utility Function converts twelve hour time string to int
func convertTime(_ twelveHourTime: String) -> Int?{

    let dateFormatter = DateFormatter()
    let dateAsString = twelveHourTime
    dateFormatter.dateFormat = "h a"
    let date = dateFormatter.date(from: dateAsString)
    
    dateFormatter.dateFormat = "HH"
    let time24 = Int(dateFormatter.string(from: date!))
    
    return time24
}

// Struct holds date components as ints
struct RequestedComponents{
    
    init(year: Int, month: Int, day: Int, weekday: Int){
        self.year = year
        self.month = month
        self.day = day
        self.weekday = weekday
    }
    
    let year: Int
    let month: Int
    let day: Int
    let weekday: Int
}
