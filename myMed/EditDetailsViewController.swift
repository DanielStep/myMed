//
//  EditDetailsViewController.swift
//  myMed
//
//  Created by Luke McCartin on 1/04/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import UIKit

class EditDetailsViewController: UIViewController {
    
    var delegate:EditDetailsViewControllerDelegate? = nil
    
    @IBOutlet weak var userGiveNameEdit : UITextField?
    @IBOutlet weak var userSurNameEdit : UITextField?
    @IBOutlet weak var userAllergyEdit :  UITextField?
    @IBOutlet weak var emergGiveNameEdit :  UITextField?
    @IBOutlet weak var emergSurNameEdit :  UITextField?
    @IBOutlet weak var emergContactNoEdit :  UITextField?
    @IBOutlet weak var docNameEdit :  UITextField?
    @IBOutlet weak var docContactNoEdit :  UITextField?
    @IBOutlet weak var docAddressEdit :  UITextField?
    
    // Originally passed from MyDetailsViewController, now pulled from CoreData.
    var passedDetails: UserDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Assigning passed details values from core data.
        passedDetails = Model.sharedInstance.personalDetails!
        
        // Adding a tap gesture to lower keyboard when screen tapped outside of keyboard.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditDetailsViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Assigning text fields to details passed in from CoreData
        if (passedDetails != nil) {
            userGiveNameEdit!.text = passedDetails!.userGiveName;userSurNameEdit!.text = passedDetails!.userSurName;userAllergyEdit!.text = passedDetails!.userAllergy;emergGiveNameEdit!.text = passedDetails!.emergGiveName;emergSurNameEdit!.text = passedDetails!.emergSurName;emergContactNoEdit!.text = passedDetails!.emergContactNo;docNameEdit!.text = passedDetails!.docName;docContactNoEdit!.text = passedDetails!.docContactNo;docAddressEdit!.text = passedDetails!.docAddress
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TO BE FINISHED - controlling user input
    @IBAction func textEditDidEnd(_ sender: AnyObject) {
        let sent = sender as! UITextField
        if sent.text!.characters.count >= 20 {
            let alert = UIAlertController(title: "Error", message: "Entry too long, try again.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(action: UIAlertAction) -> Void in
                sent.text!.removeAll()
            })
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    // Assigning textfield values to an array and sending them back to MyDetailsView.swift
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if (delegate != nil) {
            passedDetails!.userGiveName = userGiveNameEdit!.text; passedDetails!.userSurName = userSurNameEdit!.text; passedDetails!.userAllergy = userAllergyEdit!.text; passedDetails!.emergGiveName = emergGiveNameEdit!.text; passedDetails!.emergSurName = emergSurNameEdit!.text; passedDetails!.emergContactNo = emergContactNoEdit!.text; passedDetails!.docName = docNameEdit!.text; passedDetails!.docContactNo = docContactNoEdit!.text; passedDetails!.docAddress = docAddressEdit!.text
            
            delegate!.editDetailsFinished(self, details: passedDetails!)
        }
    }
    
    // Handling action based on cancel button being tapped.
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        if (delegate != nil) {
            delegate!.editDetailsFinished(self)
        }
    }
    
    
    // For ending keyboard overlay when tap gesture recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}

// Protocol for passing details between details controllers.
protocol EditDetailsViewControllerDelegate {
    func editDetailsFinished(_ controller:EditDetailsViewController, details:UserDetails)
    func editDetailsFinished(_ controller:EditDetailsViewController)
}
