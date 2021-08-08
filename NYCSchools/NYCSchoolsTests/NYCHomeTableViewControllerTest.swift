//
//  NYCHomeTableViewControllerTest.swift
//  NYCSchoolsTests
//
//  Created by Kalyan Boddapati on 08/08/2021.
//

import XCTest
@testable import NYCSchools

class NYCHomeTableViewControllerTest: XCTestCase {


    var controller: NYCHomeTableViewController!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        guard let controller = UIStoryboard(name: "Main", bundle: Bundle(for: NYCHomeTableViewController.self)).instantiateViewController(identifier: "NYCHomeTableViewController") as? NYCHomeTableViewController else {
            return XCTFail("Could not instantiate ViewController from main storyboard")
        }
        self.controller = controller
        self.controller.loadViewIfNeeded()
        self.controller.viewDidLoad()
        XCTAssertNotNil(controller.tableView,
                        "Controller should have a tableview")
    }
    
    func testTableViewDelegateIsViewController() {
      XCTAssertTrue(controller.tableView.delegate === controller,
                    "Controller should be delegate for the table view")
    }

    func testTableViewDataSourceIsViewController() {
      XCTAssertTrue(controller.tableView.dataSource === controller,
                    "Controller should be delegate for the table view")
    }


}
