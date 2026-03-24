/*****************************************************************************************
 * ___VARIABLE_productName___UITestsLaunchTests.swift
 *
 * ___VARIABLE_productName___ launch performance tests
 *
 * Author   :  ___FULLUSERNAME___ <___ORGANIZATIONNAME___>
 * Created  :  ___DATE___
 * Modified :
 *
 * Copyright © ___YEAR___ By ___FULLUSERNAME___ All rights reserved.
 ****************************************************************************************/

import XCTest

final class ___VARIABLE_productName___UITestsLaunchTests: XCTestCase {
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
