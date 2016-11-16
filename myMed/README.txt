The MyMed app is a program designed to keep track of patients medications, what times they take them and some personal details including GP and Emergency Contact Details. Not including the navigation controller, there are 7 views in total.

To assess this Application, we would recommend that you seperate the two logical features and assess one at a time as follows.

App Description

Starting at the Home Page view, you will find two large buttons with images to represent their context:

1. The MyDetails feature being the top button, or when in landscape view on smaller screen sizes, the button on the left hand side view, is a simple feature that allows the user to keep some personal details that they or their health care professional may find useful.You will find yourself being directed to what is the MyDetails page which is in fact an overview (non-editable) style of view. All the details at first use will have placeholder values as you should be able to see. To enter any Details or make changes, the user must tap the “edit” button in the top right hand corner of the page. This sends the user to an almost identical page that now allows the text fields to be tapped and details entered in each field. Once the user taps the “save” button in the top right hand corner he/she will be directed back to the overview page with the newly entered details present in their respective fields. If the user chooses to tap the “cancel” button instead, they will be redirected as with the “save” button but no newly entered details will be carried over. From here you may return to the Home Page via the embedded Navigation controller.

2. The second button image located at the bottom of the Home Page view (or to the right hand side in smaller screen sizes in landscape) is the MyMedications view. This will lead you to a page called MyMedications which, like the MyDetails page, is an overview style page. At first there will be no medications in this table view, so the user must tap the “+” button in the top right hand corner to add new medications. Tapping this button will lead the user to the AddMed view, from here the user must perform a few tasks. Following this there are two labels with corresponding text fields, the user is expected to enter the name of the medication followed by a dosage amount. These two textfields require string inputs so as to allow flexibility in how the user wishes to label their doses (such as 100mg, 1 tablet, two tablets, three etc…). Beyond this the user may also choose to tap the “Add New Time” button at the bottom of the screen which will then lead to another modal view called the AddDoseTime view although, the user may tap done at this stage and not add any dose times but this is not recommended as it would bypass the most important functionality of the app. Once being taken to the AddDoseTime view the user must pick how many times a day they take this medication, followed by the times corresponding with the previously selected frequency. Once decided the user should tap “done”, where they will be lead back to the AddMed view, there they may select the time, ensure the textfields are correct and tap “done” to return to the MyMedications view which will now display their custom created medication.

The following features have been added to satisfy ALL requirements in the Assignment 2 specification:

- Data Persisitence: Newly created Medications will now persist after the application has been closed. This is achieved by creating managed objects in Core Data from the medications in the singleton model held in memory during app operations. This occurs when the app goes to background, with the saved data loaded into the singleton model when the application is started up. This also occurs with myDetails.

- Remote Data Access: An external API is accessed to retrieve a list of medication interactions for any given (valid) medication that has been created. This list of interactions fetched and displayed in a table view when a medication is tapped from the MedicationOverview screen.

- Implementation of iOS/Cocoa Framework: The iPhone camera is used to take a photo of a given medication to be used as the medication's icon in the MedicationOverview screen. This is so the user is able to recognise which table corresponds to the medication that they're taking. This feature is accessable when adding a new medication in the AddMedViewController. The user taps on the placeholder image on the AddMed screen and is given the option of taking a photo or choosing one from the iPhone's photo gallery. One confirmed and the medication saved, this image will be displaced along side the medication in the MedOverviewViewController.

- Extra Feature: The EventKit framework and library have been used to create, edit and store reminders for the times that the user has selected to take their medication, corresponding to the Dose Times that they have selected during creation of their new medication. This is central feature of the application. A reminder is generated when the user clicks 'Done' on the AddMed view after entering the details of the medication and selecting a Dose Profile. This can be checked by leaving the myMed application and entering the Reminder's application on the iPhone. The user will find a reminder for each DoseTime in the DoseProfile that they have selected for their medication, with instructions on which medication and the dose amount to take in the reminder notes.

- Unit Tests: tests have been written to test the following, and all tests succeed:

    1. Whether checkCalendarAuthorizationStatus() is producing valid and accurate result when checking access to EventStore.
    2. Whether Medication instance is being properly stored in the singleton model
    3. Whether well form Reminder instance is created from given Medication and DoseProfile
    4. Whether given Reminder instance is properly stored and retrievable from Event Store
    5. Whether creation of managed medical object is valid and well formed

- Adaptive Layout: The four geometries supported by the application are iPhone 5 – Portrait & Landscape AND iPhone 6 – Portrait & Landscape. The iPhone 4 is also supported in Portrait and Landscape. This was achieved using contraints, stack views and size classes. Please note that in the AddMed view, by design the medication photo/icon disappears in landscape orientation. This is by design to save space in a compact vertical space using size classes.

- App Extension: Implementation code has been written to display the next medication dose due in Today screen widget. This should be achieved by functions in the myMed app fetching all of today's reminders from the EventStore accessing the notes of the next reminder after current NSDate. This notes should be accessable by the extension app for display in the widget.
    NOTE: while implementation code is in place for this feature, issues with developer account have precluded linking of the extension app and the myMed app, making the data in accessible to the extension app. This is an issue known to the course Lecturer, who has instructed that functionality is not required, only implementation.

KNOWN ISSUES:

- Currently, deletion of medications from the MedOverview view has been implemented. Persistence of this action is working and changes are propagated to Core Data. However, there is not yet implementation for updating the reminders in the Event Store to reflect the deletion. This will involve editing the notes of reminders that correspond to the reminderID stored in the deleted medication. It will also involve detecting when no medications are using a reminder anymore and deleting that reminder. This may be implemented by scanning the whole array of medications and check each med's reminderIDs against all the reminderIDs in the EventStore, if a reminder in the EventStore doesn't match up to any medications then it gets deleted.


IMPORTANT - TESTING

Keyboard autocorrection must be turned OFF in simulator's settings app prior to testing, otherwise test entry is no accurate and tests will fail.
