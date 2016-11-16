//
//  DoseTimeViewController.swift
//  myMed
//
//  Created by Luke McCartin on 2/04/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import UIKit

class DoseTimeViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var delegate:DoseTimeViewControllerDelegate? = nil
    
    // Outlets to static frequency cell.
    @IBOutlet weak var frequencyTitle : UILabel!
    @IBOutlet weak var frequencyChoice : UILabel!
    @IBOutlet var frequencyPicker : UIPickerView!
    
    // Outlets to static time cell.
    @IBOutlet weak var timeTitle : UILabel!
    @IBOutlet weak var timeChoice : UILabel!
    @IBOutlet var timePicker : UIPickerView!
    
    // Outlets to static interval cell.
    @IBOutlet weak var intervalTitle : UILabel!
    @IBOutlet weak var intervalChoice : UILabel!
    @IBOutlet var intervalPicker : UIPickerView!
    
    // Frequency Picker data.
    let frequencyPickerData:[String] = ["Once A Day","Twice A Day","Three Times A Day","Four Times A Day"]
    
    // Time Picker Data.
    let timePickerData:[[String]] = [["6 am","7 am","8 am","9 am","10 am","11 am","12 pm", "1 pm", "2 pm","3 pm","4 pm","5 pm","6 pm","7 pm","8 pm","9 pm","10 pm","11 pm","12 am"],["6 am","7 am","8 am","9 am","10 am","11 am","12 pm", "1 pm", "2 pm","3 pm","4 pm","5 pm","6 pm","7 pm","8 pm","9 pm","10 pm","11 pm","12 am"],["6 am","7 am","8 am","9 am","10 am","11 am","12 pm", "1 pm", "2 pm","3 pm","4 pm","5 pm","6 pm","7 pm","8 pm","9 pm","10 pm","11 pm","12 am"],["6 am","7 am","8 am","9 am","10 am","11 am","12 pm", "1 pm", "2 pm","3 pm","4 pm","5 pm","6 pm","7 pm","8 pm","9 pm","10 pm","11 pm","12 am"]]
    
    // Interval Picker Data.
    let intervalPickerData:[String] = ["Everyday","Every Second Day","Once A Week"]
    
    // Counter for holding value to decide number of time's shown in time picker based on choice of frequency picker.
    var frequencyPickerCount: Int = 1
    
    var intervalSelection: Int = 1
    
    var arrayOfDates = Array<Date>()
    
    // Cell heights and indexPath for handling height shown based on selection - imitating drop down feature.
    let selectedCellHeight: CGFloat = 250.0
    let unselectedCellHeight: CGFloat = 44.0
    var selectedIndexPath : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frequencyPicker.dataSource = self
        timePicker.dataSource = self
        intervalPicker.dataSource = self
        
        frequencyPicker.delegate = self
        timePicker.delegate = self
        intervalPicker.delegate = self
        
        frequencyChoice.text = "Once A Day"
        timeChoice.text = "6 am"
        intervalChoice.text = "Everyday"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data based per picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == timePicker {
            return frequencyPickerCount
        } else {
            return 1
        }
    }
    
    // The number of rows of data per picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == frequencyPicker {
            return frequencyPickerData.count
        }
        else if pickerView == timePicker {
            return timePickerData[0].count
        } else {
            return intervalPickerData.count
        }
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == frequencyPicker {
            return frequencyPickerData[row]
        }
        else if pickerView == timePicker {
            return timePickerData[component][row]
        } else {
            return intervalPickerData[row]
        }
    }
    
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // Adjusting time picker data based on frequency picker choice and updating selection text.
        if pickerView == frequencyPicker {
            frequencyPickerCount = row.hashValue + 1
            timePicker!.reloadAllComponents()
            frequencyChoice.text = frequencyPickerData[row]
        }
        
        // Updating selection text of time picker based on choice.
        if pickerView == timePicker {
            var timesArray : [String] = []
            var componentNumber : Int = 0
            repeat {
                timesArray.append(timePickerData[componentNumber][timePicker.selectedRow(inComponent: componentNumber)])
                componentNumber = componentNumber + 1
            } while timePicker.numberOfComponents > timesArray.count
            
            timeChoice.text = timesArray.joined(separator: ", ")
        }
        
        // Updating selection text of interval picker based on choice.
        if pickerView == intervalPicker {
            intervalChoice.text = intervalPickerData[row]
            intervalSelection = intervalPicker.selectedRow(inComponent: 0)
            switch intervalSelection {
                case 0:
                    intervalSelection = 1
                case 1:
                    intervalSelection = 2
                case 2:
                    intervalSelection = 7
                default:
                    intervalSelection = 1
            }
            print(intervalSelection)
        }
    }
    
    // Allowing for drop down style functionality for pickers in cells
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == selectedIndexPath{
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        
         tableView.reloadData()
    }
    
    // Determining height of cells so that only selected cell picker is shown
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath == selectedIndexPath) {
            return selectedCellHeight
        } else {
            return unselectedCellHeight
        }
    }

    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // When the done button is tapped, an array is instantiated and the times chosen placed in and converted to NSDates to be passed back to AddMedView
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        var chosenDoseTimes : [String] = []
        var componentNumber : Int = 0
        repeat {
            chosenDoseTimes.append(timePickerData[componentNumber][timePicker!.selectedRow(inComponent: componentNumber)])
            componentNumber = componentNumber + 1
        }while timePicker!.numberOfComponents > chosenDoseTimes.count
        
        //Convert array of String to array of NSDate
        arrayOfDates = timeStringArrayToDateArray(chosenDoseTimes)!
        
        let testDoseProfile = DoseProfile(doseTimes: arrayOfDates as Array<Date>, dayInterval: intervalSelection)
        
        if (delegate != nil) {
            delegate!.addDoseFinished(self, passedDoseProfile: testDoseProfile)
        }
    }

    
}

protocol DoseTimeViewControllerDelegate{
    func addDoseFinished(_ controller:DoseTimeViewController, passedDoseProfile: DoseProfile)
}
