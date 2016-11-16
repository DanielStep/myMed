//
//  InteractionsTableView.swift
//  myMed
//
//  Created by Luke McCartin on 30/04/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation

class InteractionsTableView: UITableViewController {
    
    var drugName: String?
    var returnedRxcuiNo : String?
    var interactionsList = [[String:AnyObject]]()
    var interactionsArray : [String] = []
    var alphabetizedInteractions = [String:[String]] ()
    let cellIdentifier = "Cell"
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activitySpinner.hidesWhenStopped = true
        activitySpinner.startAnimating()
        
        // Query database based on drug name supplied
        Alamofire.request(.GET, "https://rxnav.nlm.nih.gov/REST/rxcui.json?name=" + drugName!).responseJSON {
            (responseData) -> Void in
            if ((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                // If drug located in database (has a rxcuiNo), database is queried for interaction information based on that rxcuiNo
                if let returnedRxcuiNo = swiftyJsonVar["idGroup"]["rxnormId"][0].string {
                    Alamofire.request(.GET, "https://rxnav.nlm.nih.gov/REST/interaction/interaction.json?rxcui=" + returnedRxcuiNo).responseJSON {
                        (responseData) -> Void in
                        if ((responseData.result.value) != nil) {
                            let returnedInteractionJson = JSON(responseData.result.value!)
                            if let returnedInteractionsObject = returnedInteractionJson["interactionTypeGroup"][0]["interactionType"][0]["interactionPair"].arrayObject {
                                self.interactionsList = returnedInteractionsObject as! [[String:AnyObject]]
                                for item in self.interactionsList {
                                    let name:String = item["interactionConcept"]![1]["minConceptItem"]!!["name"] as! String
                                    
                                    // Ensuring no names added twice
                                    if !(self.interactionsArray.contains(name)) {
                                        self.interactionsArray.append(name)
                                    }
                                }
                                self.alphabetizedInteractions = self.alphabetizeArray(self.interactionsArray)
                                self.tableView.reloadData()
                                
                            } else {
                                let alert = UIAlertController(title: "N/A", message: "No Interactions were found in the database", preferredStyle: UIAlertControllerStyle.Alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                                    self.presentViewController(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
                else {
                    let alert = UIAlertController(title: "Drug Not Found", message: "This drug was not located in the database", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            // Cause the spinner to remain until the last second.
            sleep(1)
            self.activitySpinner.stopAnimating()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Basing number of sections in table on number of keys present in returned data array
    override func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfRows = alphabetizedInteractions.keys
        return numberOfRows.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keys = alphabetizedInteractions.keys
        
        let sortedKeys = keys.sorted(by: { (a, b) -> Bool in
            a.lowercased() < b.lowercased()
        })
        
        let key = sortedKeys[section]
        
        if let interactions = alphabetizedInteractions[key] {
            return interactions.count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let keys = alphabetizedInteractions.keys.sorted(by: { (a, b) -> Bool in
            a.lowercased() < b.lowercased()
        })
        
        return keys[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! InteractionsViewCell
        
        // Fetch and Sort Keys
        let keys = alphabetizedInteractions.keys.sorted(by: { (a, b) -> Bool in
            a.lowercased() < b.lowercased()
        })
        
        // Fetch Medications for Section
        let key = keys[indexPath.section]
        
        if let medications = alphabetizedInteractions[key] {
            // Fetch Medication
            let medication = medications[indexPath.row]
            
            // Configure Cell
            cell.medicationNamelbl?.text = medication
        }
        
        return cell
    }
    
    // alhpabetizeArray code referenced from lecture example displayed by Shekhar Kalra week 5 original created retains all rights
    fileprivate func alphabetizeArray(_ array: [String]) -> [String: [String]] {
        var result = [String: [String]]()
        
        for item in array {
            let index = item.characters.index(item.startIndex, offsetBy: 1)
            let firstLetter = item.substringToIndex(index).uppercased()
            
            if result[firstLetter] != nil {
                result[firstLetter]!.append(item)
            } else {
                result[firstLetter] = [item]
            }
        }
        
        for (key, value) in result {
            result[key] = value.sorted(by: { (a, b) -> Bool in
                a.lowercased() < b.lowercased()
            })
        }
        
        return result
    }
}
