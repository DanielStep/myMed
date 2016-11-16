//
//  myMedTests.swift
//  myMedTests
//
//  Created by Daniel Stepanenko on 21/03/2016.
//

import XCTest
import EventKit
import CoreData
import Foundation
@testable import myMed

class myMedTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    // Test whether checkCalendarAuthorizationStatus() is producing valid and accurate result when checking access to EventStore
    func test1(){
    
        var referenceResults: Bool
        if (EKEventStore.authorizationStatus(for: EKEntityType.reminder) == EKAuthorizationStatus.authorized){
            referenceResults = true
        } else{
            referenceResults = false;
        }

        let reminderManager = ReminderManager()
        let results = reminderManager.checkCalendarAuthorizationStatus()
    
        XCTAssertEqual(referenceResults, results)
    }
    
    //Test whether Medication instance is being properly stored in the singleton model
    func test2(){
        let addMed = AddMedViewController()
        let medOverview = MedOverviewTableController()
        
        let testMed = Medication(medName: "TestMedication", medDosage: "100mg")
        
        medOverview.addMedFinished(addMed, passedMed: testMed)
        
        let result = Model.sharedInstance.arrayOfMeds?.contains(where: {$0.medName == "TestMedication"})
        
        XCTAssertTrue(result!)
    }
    
    //Test whether well form Reminder instance is created from given Medication and DoseProfile
    func test3(){
        let reminderManager = ReminderManager()
        
        let date = Date()
        let testDoseTimesArray: [Date] = [date]
        let testDoseProfile = DoseProfile(doseTimes: testDoseTimesArray as Array<NSDate>, dayInterval: 1)
        
        let testMed = Medication(medName: "TestMedication", medDosage: "100mg", doseProfile: testDoseProfile)
        
        let testReminder = reminderManager.createDoseReminder(testMed, doseProfile: testDoseProfile, doseTime: date)
        
        XCTAssertNotNil(testReminder)
        XCTAssertEqual(testReminder?.title, "Time to take Medications")
        XCTAssertEqual(testReminder?.notes, "TestMedication 100mg\n")
    }
    
    //Test whether given Reminder instance is properly stored and retrievable from Event Store
    func test4(){
        
        let reminderManager = ReminderManager()
        let date = Date()
        let testDoseTimesArray: [Date] = [date]
        let testDoseProfile = DoseProfile(doseTimes: testDoseTimesArray as Array<NSDate>, dayInterval: 1)

        let reminder = EKReminder(eventStore: EventStore.sharedInstance)
        
        reminder.title = "Time to take Medications"
        reminder.calendar = EventStore.sharedInstance.defaultCalendarForNewReminders()
        reminder.dueDateComponents = dateToComponents(date)
        let interval = testDoseProfile.dayInterval!
        let nilEnd = EKRecurrenceEnd()
        let rule = EKRecurrenceRule(recurrenceWith: EKRecurrenceFrequency.daily, interval: interval, end: nilEnd)
        reminder.addRecurrenceRule(rule)
        reminder.notes = "Test notes"
        
        reminderManager.saveReminderToStore(reminder)
        
        let identifier = reminder.calendarItemExternalIdentifier
        
        let calItemArray = EventStore.sharedInstance.calendarItems(withExternalIdentifier: identifier)
        
        var retrievedReminder: EKReminder?
        if(!calItemArray.isEmpty){
            retrievedReminder = calItemArray[0] as? EKReminder
        }

        XCTAssertEqual(reminder.notes, retrievedReminder!.notes)
    }
    
    //Test whether creation of managed medical object is valid and well formed
    func test5(){
        
        let appDel = AppDelegate()
        let context: NSManagedObjectContext
        
        
        context = appDel.managedObjectContext
        
        let persistenceManager = PersistenceManager(appDel: appDel)
        
        let date = Date()
        let testDoseTimesArray: [Date] = [date]
        let testDoseProfile = DoseProfile(doseTimes: testDoseTimesArray as Array<NSDate>, dayInterval: 1)
        
        let testMed = Medication(medName: "TestMedication", medDosage: "100mg", doseProfile: testDoseProfile)

        let doseProfileEntity = NSEntityDescription.entity(forEntityName: "DoseProfile", in: context)
        let medEntity = NSEntityDescription.entity(forEntityName: "Medication", in: context)
        
        let testManagedObject = persistenceManager.createMedObject(testMed, medEntity: medEntity, doseProfileEntity: doseProfileEntity)
                
        let medName = testManagedObject?.value(forKey: "name") as? String ?? ""
        
        XCTAssertEqual(medName, "TestMedication")
        
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
