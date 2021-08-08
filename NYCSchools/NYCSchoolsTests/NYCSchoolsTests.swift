//
//  NYCSchoolsTests.swift
//  NYCSchoolsTests
//
//  Created by Kalyan Boddapati on 07/08/2021.
//

import XCTest
@testable import NYCSchools

class NYCSchoolsTests: XCTestCase {

    let schoolDataManager = SchoolDataManager()
    
    func testSchoolDataLoading() {
        let expectation = self.expectation(description: "Test School data fetch")
        schoolDataManager.getAllHighSchools { (list, error) in
            XCTAssert(((list?.count ?? 0) > 0))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }

    func testSATDataLoading() {
        let expectation = self.expectation(description: "Test School data fetch")
        schoolDataManager.getSATInfo(for: "01M450", { (result, err) in
            XCTAssert(result != nil)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10)
    }

}
