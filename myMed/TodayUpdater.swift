//
//  TodayUpdater.swift
//  myMed
//
//  Created by Luke McCartin on 21/05/2016.
//

import Foundation
import EventKit

class TodayUpdater {
    
    var earliestTime: String?
    
    init() {
        self.earliestTime = nil
    }
    
    func getNextReminder(){
        
        let eventStore = EventStore.sharedInstance
        var calendar = [EKCalendar]()
        calendar.append(eventStore.defaultCalendarForNewReminders())
        
        let reminderPredicate = eventStore.predicateForReminders(in: calendar)
        eventStore.fetchReminders(matching: reminderPredicate, completion: { (reminders: [EKReminder]?) -> Void in
            
            var dueDates = [DateComponents]()
            for reminder in reminders!{
                if reminder.title == "Time to take Medications" {
                    dueDates.append(reminder.dueDateComponents!)
                }
            }
            
            if dueDates.isEmpty {
                self.earliestTime = "empty"
                return
            }
            
            var dates = [Date]()
            for components in dueDates {
                dates.append(componentsToDate(components)!)
            }
            
            var earliestDate = dates[0]
            for date in dates {
                earliestDate = (date as NSDate).earlierDate(earliestDate)
            }
            
            self.earliestTime = dateToString(earliestDate)!
        })
    }
}
