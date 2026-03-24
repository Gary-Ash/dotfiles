/*****************************************************************************************
 * ___VARIABLE_productName___UITests.swift
 *
 * ___VARIABLE_productName___ multiplatform UI tests
 *
 * Author   :  ___FULLUSERNAME___ <___ORGANIZATIONNAME___>
 * Created  :  ___DATE___
 * Modified :
 *
 * Copyright © ___YEAR___ By ___FULLUSERNAME___ All rights reserved.
 ****************************************************************************************/

import XCTest

final class ___VARIABLE_productName___UITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    @MainActor
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }
}
