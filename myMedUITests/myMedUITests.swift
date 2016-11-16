//
//  myMedUITests.swift
//  myMedUITests
//
//  Created by Daniel Stepanenko on 21/03/2016.
//

import XCTest

class myMedUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func testAddDetails() {
        
        let app = XCUIApplication()
        app.buttons["profile icon"].tap()
        
        
        let myDetailsNavigationBar = app.navigationBars["My Details"]
        myDetailsNavigationBar.buttons["Edit"].tap() // Navigating from My Details view to Edit Details view
        
        let johnTextField = app.textFields["John"]
        johnTextField.tap()
        johnTextField.typeText("Luke")
        
        
        XCTAssert(johnTextField.value as! String == "Luke") // Asserting text entered correctly
        
        let doeTextField = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 2).textFields["Doe"]
        doeTextField.tap()
        doeTextField.typeText("McCartin")
        
        XCTAssert(doeTextField.value as! String == "McCartin") // Asserting text entered correctly
        
        app.buttons["Save"].tap() // Clicking save button and subsequently navigating back to My Details view.
        
        let johnOverviewTextField = app.otherElements.containing(.navigationBar, identifier:"My Details").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 0).textFields["John"] // Locating first edited text field
        
        XCTAssert(johnOverviewTextField.value as! String == "Luke") // Asserting text carried over from Edit Details view and not lost during view transition
        
        let doeOverviewTextField = app.otherElements.containing(.navigationBar, identifier:"My Details").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 1).textFields["Doe"] // Locating second edited text field
        
        XCTAssert(doeOverviewTextField.value as! String == "McCartin") // Asserting text carried over from Edit Details view and not lost during view transition
        
        myDetailsNavigationBar.buttons["Home"].tap()
    }
    
    
    func testAddMed2(){
        
        let app2 = XCUIApplication()
        let app = app2
        app.buttons["pill icon"].tap()
        
        let tablesQuery = app.tables
        let initialCount = tablesQuery.cells.count

        
        app.navigationBars["My Medications"].buttons["Add"].tap()
        app.buttons["Add New Time"].tap()
        
        let doneButton = app.buttons["Done"]
        doneButton.tap()
        
        app2.tables.staticTexts["6am"].tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1)
        let textField = element.children(matching: .other).element(boundBy: 2).children(matching: .textField).element
        textField.tap()
        textField.typeText("testMed")
        
        let returnButton = app2.buttons["Return"]
        returnButton.tap()
        textField.typeText("\n")
        
        let textField2 = element.children(matching: .other).element(boundBy: 3).children(matching: .textField).element
        textField2.tap()
        textField2.typeText("testDose")
        returnButton.tap()
        textField2.typeText("\n")
        doneButton.tap()
        
        let addedCount = tablesQuery.cells.count
        XCTAssert(addedCount > initialCount) //Asserting that there is one greater cell than there was prior to add
        
        //Asserting contents of new cell matches the selections in AddMed
        XCTAssert(app.tables.cells.staticTexts["testMed"].exists)
        XCTAssert(app.tables.cells.staticTexts["testDose"].exists)
        XCTAssert(app.tables.cells.staticTexts["6am"].exists)
    }

}
