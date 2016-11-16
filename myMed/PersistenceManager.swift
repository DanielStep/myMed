//
//  PersistenceManager.swift
//  myMed
//
//  Created by Daniel Stepanenko on 30/04/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PersistenceManager{

    let appDel: AppDelegate
    let context: NSManagedObjectContext
    let model : Model
    
    init(){
        self.appDel = UIApplication.shared.delegate as! AppDelegate
        self.context = appDel.managedObjectContext
        self.model = Model.sharedInstance
    }
    
    //TESTING Initialiser accepts foreign AppDelegate from myMedTests for unit testing
    init(appDel: AppDelegate){
        self.appDel = appDel
        self.context = appDel.managedObjectContext
        self.model = Model.sharedInstance
    }
    
    // Entity field key declarations
    fileprivate let medEntityName = "Medication"
    fileprivate let medNameKey = "name"
    fileprivate let medAmountKey = "amount"
    fileprivate let medImageKey = "image"
    fileprivate let doseProfileRelationship = "doseprofile"
    
    fileprivate let doseProfileEntityName = "DoseProfile"
    fileprivate let intervalKey = "interval"
    fileprivate let doseTimesRelationship = "dosetimes"
    fileprivate let reminderIDRelationship = "reminder_ids"
    
    fileprivate let userDetailsEntityName = "Details"
    
    fileprivate let doseTimeEntityName = "DoseTime"
    fileprivate let timeKey = "time"
    
    fileprivate let reminderIDEntityName = "ReminderID"
    fileprivate let idKey = "id"
    
    //Function coordinates loading of Core Data
    func load(){
        loadMedArray()
        loadProfileArray()
        loadUserDetails()
    }
    
    //Function fetches all medication managed objects and uses them rebuilt medication for populating singleton model med array
    func loadMedArray(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entityDescription = NSEntityDescription.entity(forEntityName: medEntityName, in: context)
        fetchRequest.entity = entityDescription
        
        do{
            let result = try context.fetch(fetchRequest)
            if (result.count > 0) {
                //For each managed object build medication object
                for medication in result{
                    let medName = (medication as AnyObject).value(forKey: medNameKey) as? String ?? ""
                    let medDosage = (medication as AnyObject).value(forKey: medAmountKey) as? String ?? ""
                    let loadedImage = (medication as AnyObject).value(forKey: medImageKey) as? Data
                    let newImage = UIImage(data: loadedImage!)
                    let profileObj = (medication as AnyObject).value(forKey: doseProfileRelationship) as? NSManagedObject
                    
                    var doseProfile = DoseProfile?()
                    
                    //if managed object has doseprofile, build it
                    if (profileObj != nil){
                        let interval = (profileObj!.value(forKey: intervalKey)! as AnyObject).intValue
                        let doseTimeSet = profileObj!.value(forKey: doseTimesRelationship) as? NSSet
                        var doseTimeArray = [Date]()
                        for date in doseTimeSet!{
                            let time = (date as AnyObject).value(forKey: timeKey) as! Date
                            doseTimeArray.append(time)
                        }
                        let reminderIDSet = profileObj!.value(forKey: reminderIDRelationship) as? NSSet
                        var reminderIDArray = [String]()
                        for idObj in reminderIDSet!{
                            let id = (idObj as AnyObject).value(forKey: idKey) as? String ?? ""
                            reminderIDArray.append(id)
                        }
                        doseProfile = DoseProfile(doseTimes: doseTimeArray, dayInterval: interval)
                        doseProfile!.reminderIDArray = reminderIDArray
                    }
                    
                    //Instantiate new medication object and append to singleton model array
                    let newMed = Medication(medName: medName, medDosage: medDosage, doseProfile: doseProfile, medImage: newImage!)
                    model.arrayOfMeds?.append(newMed)
                }
            }
        }catch{
            print("There was an error in executeFetchRequest(): \(error)")
        }
    }
    
    //Function fetches all doseprofile managed objects and uses them to rebuild doseprofiles for populating singleton model dose profile array
    func loadProfileArray(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entityDescription = NSEntityDescription.entity(forEntityName: doseProfileEntityName, in: context)
        fetchRequest.entity = entityDescription
        
        do{
            let result = try context.fetch(fetchRequest)
            
            //if dose profile managed objects found, use key values to build doseprofile instance
            if (result.count > 0) {
                for profileObj in result{
                    let interval = ((profileObj as AnyObject).value(forKey: intervalKey)! as AnyObject).intValue
                    let doseTimeSet = (profileObj as AnyObject).value(forKey: doseTimesRelationship) as? NSSet
                    var doseTimeArray = [Date]()
                    for date in doseTimeSet!{
                        let time = (date as AnyObject).value(forKey: timeKey) as! Date
                        doseTimeArray.append(time)
                    }
                    let reminderIDSet = (profileObj as AnyObject).value(forKey: reminderIDRelationship) as? NSSet
                    var reminderIDArray = [String]()
                    for idObj in reminderIDSet!{
                        let id = (idObj as AnyObject).value(forKey: idKey) as? String ?? ""
                        reminderIDArray.append(id)
                    }
                    
                    let newDoseProfile = DoseProfile(doseTimes: doseTimeArray, dayInterval: interval)
                    newDoseProfile.reminderIDArray = reminderIDArray
                    model.arrayOfDoseProfiles?.append(newDoseProfile)
                }
            }
        }catch{
            // Error thrown from executeFetchRequest()
            print("There was an error in executeFetchRequest(): \(error)")
        }
    }
    
    //Function fetches user details managed object and uses it's key values to rebuild singleton model user details object
    func loadUserDetails() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entityDescription = NSEntityDescription.entity(forEntityName: userDetailsEntityName, in: context)
        fetchRequest.entity = entityDescription
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for detailsObj in results {
                   let usersDetails = detailsObj
                    let userGiveName = (detailsObj as AnyObject).value(forKey: "userGiveName") as? String
                    model.personalDetails!.userGiveName = userGiveName
                    let userSurName = (detailsObj as AnyObject).value(forKey: "userSurName") as? String
                    model.personalDetails!.userSurName = userSurName
                    let userAllergy = (detailsObj as AnyObject).value(forKey: "userAllergy") as? String
                    model.personalDetails!.userAllergy = userAllergy
                    let emergGiveName = (detailsObj as AnyObject).value(forKey: "emergGiveName") as? String
                    model.personalDetails!.emergGiveName = emergGiveName
                    let emergSurName = (detailsObj as AnyObject).value(forKey: "emergSurName") as? String
                    model.personalDetails!.emergSurName = emergSurName
                    let emergContactNo = (detailsObj as AnyObject).value(forKey: "emergContactNo") as? String
                    model.personalDetails!.emergContactNo = emergContactNo
                    let docName = (detailsObj as AnyObject).value(forKey: "docName") as? String
                    model.personalDetails!.docName = docName
                    let docAddress = (detailsObj as AnyObject).value(forKey: "docAddress") as? String
                    model.personalDetails!.docAddress = docAddress
                    let docContactNo = (detailsObj as AnyObject).value(forKey: "docContactNo") as? String
                    model.personalDetails!.docContactNo = docContactNo
                }
            }
        } catch {
            print("Could not load User Details")
        }
    }
    
    //Function clears Core Data and saves singleton model
    func save(){
        clearAllEntities()
        
        //Declare entities
        let doseProfileEntity = NSEntityDescription.entity(forEntityName: doseProfileEntityName, in: context)
        let medEntity = NSEntityDescription.entity(forEntityName: medEntityName, in: context)
        let detailsEntity = NSEntityDescription.entity(forEntityName: userDetailsEntityName, in: context)
        let userDetails = NSManagedObject(entity: detailsEntity!, insertInto: context)

        //For all medications, and user details in singleton model, create managed objects and save to Core Data
        //All doseprofiles associated to saved medications will also be saved, no need to save seperately
        if (model.arrayOfMeds != nil){
            for medication in model.arrayOfMeds!{
                let newMed = createMedObject(medication, medEntity: medEntity, doseProfileEntity: doseProfileEntity)
                saveObj(newMed)
            }
        }
        
        if model.personalDetails != nil {
            userDetails.setValue(model.personalDetails!.userGiveName, forKey: "userGiveName")
            userDetails.setValue(model.personalDetails!.userSurName, forKey: "userSurName")
            userDetails.setValue(model.personalDetails!.userAllergy, forKey: "userAllergy")
            userDetails.setValue(model.personalDetails!.emergGiveName, forKey: "emergGiveName")
            userDetails.setValue(model.personalDetails!.emergSurName, forKey: "emergSurName")
            userDetails.setValue(model.personalDetails!.emergContactNo, forKey: "emergContactNo")
            userDetails.setValue(model.personalDetails!.docName, forKey: "docName")
            userDetails.setValue(model.personalDetails!.docContactNo, forKey: "docContactNo")
            userDetails.setValue(model.personalDetails!.docAddress, forKey: "docAddress")
            saveObj(userDetails)
        }
    }
    
    //Function creates medication managed object from medication instance
    //Checks whether doseprofile also exists in Core Data, if so uses existing to avoid creating duplicate dose profile managed objects
    func createMedObject(_ medication: Medication?, medEntity: NSEntityDescription?, doseProfileEntity: NSEntityDescription?) -> NSManagedObject?{
        
        if (medication != nil){
            
            let newMed = NSManagedObject(entity: medEntity!, insertInto: context)
            var doseProfile = NSManagedObject?()
            let reminderID = medication?.doseProfile?.reminderIDArray?.first
            
            //Check whether doseprofile with ID already exists in CoreData
            if (reminderID != nil){
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
                let entityDescription = NSEntityDescription.entity(forEntityName: doseProfileEntityName, in: context)
                fetchRequest.entity = entityDescription
                let predicate = NSPredicate(format: "ANY reminder_ids.id like %@", reminderID!)
                fetchRequest.predicate = predicate
                
                //If existing doseprofile, use existing for managed medication to avoid duplicates
                //Otherwise create new doseprofile managed object from singleton model
                do{
                    let result = try context.fetch(fetchRequest)
                    if (result.count > 0) {
                        doseProfile = result.first as? NSManagedObject
                    } else{
                        doseProfile = createDoseProfileObject(medication!.doseProfile, doseProfileEntity: doseProfileEntity)
                    }
                }catch {
                    print("There was an error in executeFetchRequest(): \(error)")
                }
            }
            newMed.setValue(medication!.medDosage, forKey: medAmountKey)
            newMed.setValue(medication!.medName, forKey: medNameKey)
            newMed.setValue(doseProfile, forKey: doseProfileRelationship)
            if (medication!.medImage != nil) {
                let convertedImage = UIImageJPEGRepresentation(medication!.medImage!, 1)
                newMed.setValue(convertedImage, forKey: medImageKey)
            }
            return newMed
        }else{
            return nil
        }
    }

    //Function creates doseprofile managed object from dose profile instance
    func createDoseProfileObject(_ profile: DoseProfile?, doseProfileEntity: NSEntityDescription?) -> NSManagedObject?{
        
        if (profile != nil){
            let newDoseProfile = NSManagedObject(entity: doseProfileEntity!, insertInto: context)
            let reminderIDSet = getReminderIDSet(profile!,doseProfileEntity: doseProfileEntity,  newProfileObj: newDoseProfile)
            let doseTimeSet = getDoseTimeSet(profile!,doseProfileEntity: doseProfileEntity,  newProfileObj: newDoseProfile)
            
            newDoseProfile.setValue(profile!.dayInterval, forKey: intervalKey)
            print(newDoseProfile)
            saveObj(newDoseProfile)
            
            return newDoseProfile
        }else{
            return nil
        }
    }

    //for each DoseProfile create set from DoseTimesArray to model to-many relationship
    func getDoseTimeSet(_ profile: DoseProfile, doseProfileEntity: NSEntityDescription?,  newProfileObj: NSManagedObject) -> NSMutableSet? {
        
        let doseTimeEntity = NSEntityDescription.entity(forEntityName: doseTimeEntityName, in: context)

        if (profile.doseTimes != nil){
            for doseTime in profile.doseTimes!{
                let newDoseTime = NSManagedObject(entity: doseTimeEntity!, insertInto: context)
                newDoseTime.setValue(doseTime, forKey: timeKey)
                newProfileObj.mutableSetValue(forKey: doseTimesRelationship).add(newDoseTime)
            }
        }
        
        let doseTimeSet = newProfileObj.mutableSetValue(forKey: doseTimesRelationship)
        return doseTimeSet
    }
    
    //for each DoseProfile create set from ReminderIDArray, as above for getDoseTimeSet()
    func getReminderIDSet(_ profile: DoseProfile, doseProfileEntity: NSEntityDescription?,  newProfileObj: NSManagedObject) -> NSMutableSet? {
        
        let reminderIDEntity = NSEntityDescription.entity(forEntityName: "ReminderID", in: context)
        
        if (profile.reminderIDArray != nil){
            for id in profile.reminderIDArray!{
                let newReminderID = NSManagedObject(entity: reminderIDEntity!, insertInto: context)
                newReminderID.setValue(id, forKey: "id")
                newProfileObj.mutableSetValue(forKey: "reminder_ids").add(newReminderID)
            }
        }
        let reminderIDSet = newProfileObj.mutableSetValue(forKey: reminderIDRelationship)
        return reminderIDSet
    }

    //Function saves the managed object from the managed context to the database for persistence
    func saveObj(_ object: NSManagedObject?){
    
        if(object != nil){
            do{
                try object!.managedObjectContext?.save()
            } catch{
                let saveError = error as NSError
                print(saveError)
            }
        }
    }
    
    //Function cleans Core Data upon saving singleton model to avoid duplicates
    func clearAllEntities(){
        let reminderIDEntity = NSEntityDescription.entity(forEntityName: reminderIDEntityName, in: context)
        let doseTimeEntity = NSEntityDescription.entity(forEntityName: doseTimeEntityName, in: context)
        let doseProfileEntity = NSEntityDescription.entity(forEntityName: doseProfileEntityName, in: context)
        let medEntity = NSEntityDescription.entity(forEntityName: medEntityName, in: context)
        
        deleteAllObjectsForEntity(reminderIDEntity!)
        deleteAllObjectsForEntity(doseTimeEntity!)
        deleteAllObjectsForEntity(doseProfileEntity!)
        deleteAllObjectsForEntity(medEntity!)
    }
    
    func deleteAllObjectsForEntity(_ entity: NSEntityDescription) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 50
        
        do{
            let fetchResults = try context.fetch(fetchRequest)
            
            if let managedObjects = fetchResults as? [NSManagedObject] {
                for object in managedObjects {
                    context.delete(object)
                }
            }
        } catch {
            print("There was an error in executeFetchRequest(): \(error)")
        }
    }
}
