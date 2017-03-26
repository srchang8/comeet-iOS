//
//  comeetUITests.swift
//  comeetUITests
//
//  Created by Ricardo Contreras on 3/6/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import XCTest

class comeetUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLogin() {

        let app = XCUIApplication()
        
        if (app.buttons["Log out"].exists) {
            app.buttons["Log out"].tap()
        }
        
        app.buttons["Login"].tap()
        
        // Wait for ADAL SDK Web View to load
        sleep(5)
        
        if (app.staticTexts["•••"].exists) {
            app.staticTexts["•••"].tap()
            app.staticTexts["Forget"].tap()
        }
        
        app.buttons["Sign in"].tap()

        let emailOrPhoneTextField = app.textFields["Email or phone"]
        emailOrPhoneTextField.tap()
        emailOrPhoneTextField.typeText("jablack@meetl.ink")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("Comeet599")
        
        
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.tap()
        app.buttons["Sign in"].tap()
        
        // Wait for dismiss and push animation
        sleep(5)
        
        XCTAssert(app.navigationBars["Menu"].exists)

    }
}
