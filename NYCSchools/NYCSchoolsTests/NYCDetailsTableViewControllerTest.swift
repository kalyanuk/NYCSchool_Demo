//
//  NYCDetailsTableViewControllerTest.swift
//  NYCSchoolsTests
//
//  Created by Kalyan Boddapati on 08/08/2021.
//

import XCTest
@testable import NYCSchools

class NYCDetailsTableViewControllerTest: XCTestCase {
    
    var controller: NYCDetailsTableViewController!
    var school = School(dbn: "01M450", school_name: "East Side Community School", overview_paragraph: "We are a small college preparatory school that takes pride in our engaging and challenging curriculum. In all classes, our students creatively apply what they learn to complete interesting and rigorous projects. Our teachers know our students well and provide the support they need to succeed. Because we believe that it is important for students to discover and develop their passions, we offer our students an amazing amount of extra curricular activities and travel opportunities that they enjoy tremendously. East Side is a great setting for students who are interested in being part of a vibrant and diverse community that focuses on academic, social, and emotional growth.", location: "420 East 12th Street, Manhattan NY 10009 (40.729152, -73.982472)", phone_number: "212-460-8467", school_email: "tomm@eschs.org", website: "www.eschs.org", subway: "6 to Astor Place ; L to 1st Ave", bus: "M1, M101, M102, M103, M14A, M14D, M15, M15-SBS, M2, M23, M3, M8, M9", borough: "Manhattan")
    
    var satResult = SATResult(dbn: "01M450", school_name: "East Side Community School", num_of_sat_test_takers: "44", sat_critical_reading_avg_score: "230", sat_math_avg_score: "30", sat_writing_avg_score: "40")
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        guard let controller = UIStoryboard(name: "Main", bundle: Bundle(for: NYCDetailsTableViewController.self)).instantiateViewController(identifier: "DetailView") as? NYCDetailsTableViewController else {
            return XCTFail("Could not instantiate ViewController from main storyboard")
        }
        self.controller = controller
        self.controller.school = school
        self.controller.satResult = satResult
        self.controller.loadViewIfNeeded()
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

    func testNumberOfRow() {
        XCTAssert(self.controller.tableView.numberOfRows(inSection: 0) == 5)
    }
    
    func testAddressCell_0() {
        let cell: NYCDefaultCell = self.controller.tableView.dataSource?.tableView(self.controller.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! NYCDefaultCell
        XCTAssert(cell.titleLabel.text == "East Side Community School")
    }
    
    func testAddressCell_1() {
        let cell: NYCInfoLinkCell = self.controller.tableView.dataSource?.tableView(self.controller.tableView, cellForRowAt: IndexPath(row: 1, section: 0)) as! NYCInfoLinkCell
        XCTAssert(cell.titleLabel.text == "420 East 12th Street, Manhattan NY 10009 ")
    }

    func testAddressCell_2() {
        let cell: NYCInfoLinkCell = self.controller.tableView.dataSource?.tableView(self.controller.tableView, cellForRowAt: IndexPath(row: 2, section: 0)) as! NYCInfoLinkCell
        XCTAssert(cell.titleLabel.text == "tomm@eschs.org")
    }


    func testAddressCell_3() {
        let cell: NYCInfoLinkCell = self.controller.tableView.dataSource?.tableView(self.controller.tableView, cellForRowAt: IndexPath(row: 3, section: 0)) as! NYCInfoLinkCell
        XCTAssert(cell.titleLabel.text == "212-460-8467")
    }

    func testAddressCell_4() {
        let cell: NYCInfoLinkCell = self.controller.tableView.dataSource?.tableView(self.controller.tableView, cellForRowAt: IndexPath(row: 4, section: 0)) as! NYCInfoLinkCell
        XCTAssert(cell.titleLabel.text == "www.eschs.org")
    }

    
    func testSATSection_No_of_Rows() {
        XCTAssert(self.controller.tableView.numberOfRows(inSection: 1) == 4)
    }

    func testSATSection_cell_0() {
        let cell: NYCRightInfoCell = self.controller.tableView.dataSource?.tableView(self.controller.tableView, cellForRowAt: IndexPath(row: 0, section: 1)) as! NYCRightInfoCell
        XCTAssert(cell.subTitleLabel.text == "44")
    }

    func testSATSection_cell_1() {
        let cell: NYCRightInfoCell = self.controller.tableView.dataSource?.tableView(self.controller.tableView, cellForRowAt: IndexPath(row: 1, section: 1)) as! NYCRightInfoCell
        XCTAssert(cell.subTitleLabel.text == "30")
    }

    
    func testSATSection_cell_2() {
        let cell: NYCRightInfoCell = self.controller.tableView.dataSource?.tableView(self.controller.tableView, cellForRowAt: IndexPath(row: 2, section: 1)) as! NYCRightInfoCell
        XCTAssert(cell.subTitleLabel.text == "40")
    }
    
    func testSATSection_cell_3() {
        let cell: NYCRightInfoCell = self.controller.tableView.dataSource?.tableView(self.controller.tableView, cellForRowAt: IndexPath(row: 3, section: 1)) as! NYCRightInfoCell
        XCTAssert(cell.subTitleLabel.text == "230")
    }


    func testOverview_No_of_Rows() {
        XCTAssert(self.controller.tableView.numberOfRows(inSection: 2) == 1)
    }

    func testOverview_cell_0() {
        let cell: NYCTextCell = self.controller.tableView.dataSource?.tableView(self.controller.tableView, cellForRowAt: IndexPath(row: 0, section: 2)) as! NYCTextCell
        XCTAssert(cell.titleLabel.text!.contains("We are a small college preparatory school that takes pride in our"))
    }
    
    func testTransportation_No_of_Rows() {
        XCTAssert(self.controller.tableView.numberOfRows(inSection: 3) == 2)
    }

    func testTransportation_cell_0() {
        let cell: NYCDefaultCell = self.controller.tableView.dataSource?.tableView(self.controller.tableView, cellForRowAt: IndexPath(row: 0, section: 3)) as! NYCDefaultCell
        XCTAssert(cell.subTitleLabel.text!.contains("M1, M101, M102,"))
    }

    func testTransportation_cell_1() {
        let cell: NYCDefaultCell = self.controller.tableView.dataSource?.tableView(self.controller.tableView, cellForRowAt: IndexPath(row: 1, section: 3)) as! NYCDefaultCell
        XCTAssert(cell.subTitleLabel.text!.contains("6 to Astor"))
    }


}
