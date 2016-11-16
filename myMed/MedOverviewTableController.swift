//
//  MedOverviewController.swift
//  myMed
//
//  Created by Daniel Stepanenko on 30/03/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//
// Added framework pods

import UIKit
import Alamofire
import SwiftyJSON

class MedOverviewTableController: UITableViewController, AddMedViewControllerDelegate {

    //Temporary datastructure for storing Medications, loaded periodically from Model Singleton
    var arrayOfMeds = Model.sharedInstance.arrayOfMeds
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //delegate protocol method to retrieving newly created medications when done button tapped in AddMedController
    func addMedFinished(_ controller: AddMedViewController, passedMed: Medication?) {
        
        if(passedMed != nil){
            Model.sharedInstance.arrayOfMeds?.append(passedMed!)
        }
        arrayOfMeds = Model.sharedInstance.arrayOfMeds!
        self.tableView.reloadData()
        
        controller.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfMeds!.count
    }

    //Method populates tableview with dynamic custom cells
    //Contains logic for handling cell presentation in the presence of nil Medication or DoseProfile
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = arrayOfMeds?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "medPrototypeCell", for: indexPath) as! MedTableViewCell
        
        //Populate Med cell labels with relevant data from associated med in array
        //If data nil, then populated with empty string
        if (data != nil){
        cell.lblMedName?.text = data!.medName
        cell.lblAmount?.text = data!.medDosage
        cell.imageMed.layer.cornerRadius = 55
        cell.imageMed.layer.masksToBounds = true
            if (data!.medImage != nil) {
                cell.imageMed?.image = data!.medImage
            } else {
                let image = UIImage(named: "pillpic-icon.png")
                cell.imageMed.image = image
            }
            if(data!.doseProfile != nil){
                let stringOfTimes = tokenizeDoseTimeArray(data!.doseProfile!.doseTimes!)
                cell.lblDoseTimes?.text = stringOfTimes
                let intervalString = String(data!.doseProfile!.dayInterval!)
                if(intervalString != "nil"){
                    cell.lblInterval.text = "Every " + intervalString + " Days"
                } else{
                    cell.lblInterval.text = ""
                }
            }else{
                cell.lblDoseTimes?.text = ""
                cell.lblInterval.text = ""
            }
        }
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Pass self to AddMedViewController for running addMedFinished()
        if (segue.identifier == "addMedSegue") {
            let svc = segue.destination as! AddMedViewController;
            svc.delegate = self
        }
        //Seque to Medication information detail view
        if (segue.identifier == "medInteractionsSegue") {
            let vc = segue.destination as! InteractionsTableView
            if let button = sender as? UIButton {
                let cell = button.superview?.superview as! MedTableViewCell
                let tableTitle: String = (cell.lblMedName!.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!
                vc.title = tableTitle.capitalized
                vc.drugName = tableTitle
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
                Model.sharedInstance.arrayOfMeds!.remove(at: indexPath.row)
                arrayOfMeds!.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
