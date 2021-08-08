//
//  AddressSectionTest.swift
//  NYCSchoolsTests
//
//  Created by Kalyan Boddapati on 08/08/2021.
//

import XCTest
@testable import NYCSchools
class AddressSectionTest: XCTestCase {

    var adrSection: AddressSection = AddressSection(school: School(dbn: "01M450", school_name: "East Side Community School", overview_paragraph: "We are a small college preparatory school that takes pride in our engaging and challenging curriculum. In all classes, our students creatively apply what they learn to complete interesting and rigorous projects. Our teachers know our students well and provide the support they need to succeed. Because we believe that it is important for students to discover and develop their passions, we offer our students an amazing amount of extra curricular activities and travel opportunities that they enjoy tremendously. East Side is a great setting for students who are interested in being part of a vibrant and diverse community that focuses on academic, social, and emotional growth.", location: "420 East 12th Street, Manhattan NY 10009 (40.729152, -73.982472)", phone_number: "212-460-8467", school_email: "tomm@eschs.org", website: "www.eschs.org", subway: "6 to Astor Place ; L to 1st Ave", bus: "M1, M101, M102, M103, M14A, M14D, M15, M15-SBS, M2, M23, M3, M8, M9", borough: "Manhattan"))
    
    func testNumberOfRows() {
        XCTAssert(adrSection.cells.count == 5)
    }

}
