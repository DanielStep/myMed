//
//  ReminderManager.swift
//  myMed
//
//  Created by Daniel Stepanenko on 15/05/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import Foundation
import EventKit

class ReminderManager {
    
    init(){
    }
    
    //Function checks whether reminder need to be created or edited
    func checkDoseReminders(_ medication: Medication?){
        
        if (checkCalendarAuthorizationStatus() == true || medication != nil){
            var profile = medication!.doseProfile!
            
            //Check whether reminders have already been created for this dose Profile
            //If empty, create reminder for each dosetime
            if(profile.reminderIDArray!.isEmpty){
                for time in profile.doseTimes!{
                    var reminder = createDoseReminder(medication!, doseProfile: profile, doseTime: time as Date)
                    var reminderID = reminderToIdentifier(reminder)
                    saveReminderToStore(reminder)
                    if (reminderID != nil){
                        profile.reminderIDArray!.append(reminderID!)
                    }
                }
            }
            //if not empty, selecting existing profile with reminders created. Match ID and edit reminder
            else{
                for reminderID in profile.reminderIDArray!{
                    let reminder = identifierToReminder(reminderID)
                    editDoseReminderNotes(medication!, doseProfile: profile, reminder: reminder)
                    saveReminderToStore(reminder)
                }
            }
        }
    }
    
    //Function checks for EventStore authorization for reminders.
    func checkCalendarAuthorizationStatus() -> Bool{
        
        var status = false
        if(EKEventStore.authorizationStatus(for: EKEntityType.reminder) == EKAuthorizationStatus.denied
            || EKEventStore.authorizationStatus(for: EKEntityType.reminder) == EKAuthorizationStatus.restricted)
        {
            print("Reminder not created. Access Restricted or Denied. Please go to settings>privacy and grant access to Reminders")
        }
        else if (EKEventStore.authorizationStatus(for: EKEntityType.reminder) == EKAuthorizationStatus.notDetermined)
        {
            print("Access Undermined")
        }
        else if (EKEventStore.authorizationStatus(for: EKEntityType.reminder) == EKAuthorizationStatus.authorized)
        {
            print("Access to Reminders Authorised")
            status = true
        }
        return status
    }
    
    //Function builds a reminder from med and doseprofile details
    func createDoseReminder(_ medication: Medication, doseProfile: DoseProfile, doseTime: Date) -> EKReminder?{
        
        let reminder = EKReminder(eventStore: EventStore.sharedInstance)
        reminder.title = "Time to take Medications"
        reminder.calendar = EventStore.sharedInstance.defaultCalendarForNewReminders()
        reminder.dueDateComponents = dateToComponents(doseTime)
        let interval = doseProfile.dayInterval!
        let nilEnd = EKRecurrenceEnd()
        let rule = EKRecurrenceRule(recurrenceWith: EKRecurrenceFrequency.daily, interval: interval, end: nilEnd)
        reminder.addRecurrenceRule(rule)
        
        editDoseReminderNotes(medication, doseProfile: doseProfile, reminder: reminder)
        return reminder
    }
    
    //Function appends medication name and dose amount to existing reminder notes
    func editDoseReminderNotes(_ medication: Medication, doseProfile: DoseProfile, reminder: EKReminder?){
        
        if(reminder != nil){
            let noteEntry = medication.medName! + " " + medication.medDosage! + "\n"
            
            if (reminder!.notes != nil){
                reminder!.notes! += noteEntry
                print(reminder!.notes!)
            }else{
                print("notes is nil")
                reminder!.notes = noteEntry;
                print(reminder!.notes!)
            }
        }
    }
    
    //Function saves built reminder to EventStore
    func saveReminderToStore(_ reminder: EKReminder?){
        
        if(reminder != nil){
            do{
                try EventStore.sharedInstance.save(reminder!, commit: true)
                print("Reminder saved")
            }catch{
                print("Error saving new reminder : \(error)")
            }
        }
    }
}
