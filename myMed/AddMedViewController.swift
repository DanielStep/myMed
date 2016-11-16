//
//  AddMedViewController.swift
//  myMed
//
//  Created by Daniel Stepanenko on 28/03/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import UIKit
import EventKit

class AddMedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DoseTimeViewControllerDelegate {
    
    var delegate:AddMedViewControllerDelegate? = nil
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var selectedProfile: DoseProfile? = nil
    var arrayOfDoseProfiles: Array<DoseProfile>?
    
    var takenImage: UIImage?
    
    //MARK: IBOutlets
    @IBOutlet weak var medNameText: UITextField!
    @IBOutlet weak var doseAmountText: UITextField!
    @IBOutlet weak var doseTableView: UITableView!
    @IBOutlet weak var medImage: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrayOfDoseProfiles = Model.sharedInstance.arrayOfDoseProfiles!
        doseTableView.delegate = self
        doseTableView.dataSource = self
        self.doseTableView.reloadData()
        
        imagePicker.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddMedViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // ensures table selections can still be made for dose times while allowing keyboard dismissal on tap.
        tap.cancelsTouchesInView = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Photo Handling functions
    @IBAction func addPhoto(_ sender: AnyObject) {
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .camera
                imagePicker.cameraCaptureMode = .photo
                imagePicker.showsCameraControls = true
                present(imagePicker, animated: true, completion: {})
            } else {
                let alert = UIAlertController(title: "Rear camera does not exist", message: "Application cannot access the camera.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(action: UIAlertAction) -> Void in})
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Camera inaccessable", message: "Opening Photo Library.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(action: UIAlertAction) -> Void in self.choosePicture()
                self.present(self.imagePicker, animated: true, completion: {})
            })
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    // adding a nav bar to allow for swapping between camera and photo library
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if(imagePicker.sourceType == UIImagePickerControllerSourceType.photoLibrary && UIImagePickerController.isSourceTypeAvailable(.camera)){
            let button = UIBarButtonItem(title: "Take picture", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddMedViewController.showCamera))
            viewController.navigationItem.rightBarButtonItem = button
        }else if imagePicker.sourceType == UIImagePickerControllerSourceType.camera{
            let button = UIBarButtonItem(title: "Choose picture", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddMedViewController.choosePicture))
            viewController.navigationItem.rightBarButtonItem = button
            viewController.navigationController?.isNavigationBarHidden = false
            viewController.navigationController?.navigationBar.isTranslucent = true
        }
    }
    
    func showCamera(){
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
    }
    
    func choosePicture(){
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
    }
    
    /*
     called once image selection finished. Writes image to photo album, calls imageWasSavedSuccessfully function and dismisses view controller once finished.
    */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage:UIImage = (info[UIImagePickerControllerOriginalImage]) as? UIImage {
            let selectorToCall = #selector(AddMedViewController.imageWasSavedSuccessfully(_:didFinishSavingWithError:context:))
            UIImageWriteToSavedPhotosAlbum(pickedImage, self, selectorToCall, nil)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    // handles error if applicable, assigns taken image variable with the imaged selected and places it in the UIImage.
    func imageWasSavedSuccessfully(_ image: UIImage, didFinishSavingWithError error: NSError!, context: UnsafeMutableRawPointer) {
        if let anError = error {
            print("Error while saving image \(anError)")
        } else {
            takenImage = image
            DispatchQueue.main.async(execute: { () -> Void in self.medImage.setImage(image, for: UIControlState())})
            
        }
        self.medImage.layer.cornerRadius = 50
        self.medImage.layer.masksToBounds = true
    }
    
    // called if camera/ photolibrary cancelled by user
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // for removing keyboard when background tapped.
    func dismissKeyboard() {
        medNameText.resignFirstResponder()
        doseAmountText.resignFirstResponder()
    }

    //Method passes textfield contents and selected DoseProfile to a newly initialised Medications
    //calls delegate method from MedOverviewController to pass new medication to MedOverview
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        
        let newMedication = buildNewMedication(selectedProfile)
        Model.sharedInstance.arrayOfDoseProfiles = arrayOfDoseProfiles
        
        if (delegate != nil) {
            delegate!.addMedFinished(self, passedMed: newMedication)
        }
    }
    
    //Function takes in selected dose profile, textfield strings and taken image
    //Creates new medication object from avaliable components
    //Where passed doseprofile not nil, calls ReminderManager to add corresponding reminder to Store
    func buildNewMedication(_ doseProfile: DoseProfile?) -> Medication?{
        
        var newMedication: Medication? = nil
        
        let newMedName = medNameText.text
        let newDoseAmount = doseAmountText.text
        let selectedDoseProfile = doseProfile
        
        var newImage = UIImage(named: "pillpic-icon.png")
        if takenImage != nil {
            newImage = takenImage
        }
        //If selectedProfile not nill, the create medication object and reminder
        if (newMedName != "" && newDoseAmount != "" && selectedProfile != nil && newImage != nil) {
            newMedication = Medication(medName: newMedName!, medDosage: newDoseAmount!, doseProfile: selectedDoseProfile!, medImage: newImage!)
            let reminderManager = ReminderManager()
            reminderManager.checkDoseReminders(newMedication)
        } else if (newMedName != "" && newDoseAmount != "" && selectedProfile != nil){
            newMedication = Medication(medName: newMedName!, medDosage: newDoseAmount!, doseProfile: selectedDoseProfile!)
            let reminderManager = ReminderManager()
            reminderManager.checkDoseReminders(newMedication)
        }
        //If doserpfile is nil, don't create reminder
        else if (newMedName != "" && newDoseAmount != "" && newImage != nil){
            newMedication = Medication(medName: newMedName!, medDosage: newDoseAmount!, medImage: newImage!)
        } else if (newMedName != "" && newDoseAmount != ""){
            newMedication = Medication(medName: newMedName!, medDosage: newDoseAmount!)
        }
        return newMedication
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    //Delegate method for retrieving doseProfile from DoseTimeViewController
    func addDoseFinished(_ controller:DoseTimeViewController, passedDoseProfile: DoseProfile){
        
        arrayOfDoseProfiles!.append(passedDoseProfile)
        self.doseTableView.reloadData()
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfDoseProfiles!.count
    }
    
    //Method populates dose table view with new dynamic custom cells of doseProfile
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = arrayOfDoseProfiles![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "doseTableViewCell", for: indexPath) as! DoseTableViewCell
        
        let stringOfTimes = tokenizeDoseTimeArray(data.doseTimes!)
        cell.doseTimes?.text = stringOfTimes
        cell.doseInterval?.text = "Every " + String(data.dayInterval!) + " days"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow
        let rowNum = indexPath?.row
        
        selectedProfile = arrayOfDoseProfiles![rowNum!]
    }
    
    //Pass self as delegate to DoseTimeViewController for addDoseFinished()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "addDoseSegue") {
            let vc = segue.destination as! DoseTimeViewController
            vc.delegate = self
        }
    }
}

protocol AddMedViewControllerDelegate{
    func addMedFinished(_ controller:AddMedViewController, passedMed: Medication?)
}

