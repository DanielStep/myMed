//
//  MyDetailsViewController.swift
//  myMed
//
//  Created by Luke McCartin on 31/03/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import UIKit

class MyDetailsViewController: UIViewController, EditDetailsViewControllerDelegate {
    
    @IBOutlet weak var userGiveName : UITextField?
    @IBOutlet weak var userSurName : UITextField?
    @IBOutlet weak var userAllergy :  UITextField?
    @IBOutlet weak var emergGiveName :  UITextField?
    @IBOutlet weak var emergSurName :  UITextField?
    @IBOutlet weak var emergContactNo :  UITextField?
    @IBOutlet weak var docName :  UITextField?
    @IBOutlet weak var docContactNo :  UITextField?
    @IBOutlet weak var docAddress :  UITextField?
    
    // Variable for holding users details from CoreData.
    var userDetails: UserDetails?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Assigning textfields data pulled in from CoreData.
        userDetails = Model.sharedInstance.personalDetails!
        userGiveName!.text = userDetails!.userGiveName; userSurName!.text = userDetails!.userSurName; userAllergy!.text = userDetails!.userAllergy; emergGiveName!.text = userDetails!.emergGiveName; emergSurName!.text = userDetails!.emergSurName; emergContactNo!.text = userDetails!.emergContactNo; docName!.text = userDetails!.docName; docContactNo!.text = userDetails!.docContactNo; docAddress!.text = userDetails!.docAddress;
    }

    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // If cancel button tapped in EditDetailsViewController this function is called to dismiss view.
    func editDetailsFinished(_ controller: EditDetailsViewController) {
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    // Assigning values to appropriate text field from array sent back from EditDetailsViewController,swift (Overloaded function)
    func editDetailsFinished(_ controller: EditDetailsViewController, details:UserDetails) {
        userGiveName!.text = details.userGiveName; userSurName!.text = details.userSurName; userAllergy!.text = details.userAllergy; emergGiveName!.text = details.emergGiveName; emergSurName!.text = details.emergSurName; emergContactNo!.text = details.emergContactNo; docName!.text = details.docName; docContactNo!.text = details.docContactNo; docAddress!.text = details.docAddress
        
        controller.dismiss(animated: true, completion: nil)
    }

    // Segue to edit details view.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editDetailsSegue") {
            let vc = segue.destination as! EditDetailsViewController
            vc.delegate = self
        }
    }
}
