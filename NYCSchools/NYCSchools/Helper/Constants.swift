//
//  Constants.swift
//  NYCSchools
//
//  Created by Kalyan Boddapati on 07/08/2021.
//

import Foundation
struct NYSConfig {
    static let SCHOOL_API_ENDPOINT = "uq7m-95z8.json"
    static let SAT_API_ENDPOINT = "f9bf-2cp4.json"
    
    static let API_URL = "https://data.cityofnewyork.us/resource/"
    static let APPTOKEN = "xYjnIfN0z2BJRZh0YVMa9lECR"
    
    static let APPTOKEN_KEY = "$$app_token"
}

struct Constants {
    static let appTitle = "NYC Schools"
    static let searchPlaceholder = "Search by school name"
    static let detailsTitle = "School Details"
    
    static let info = "Information"
    static let satResults = "SAT Results"
    static let overview = "Overview"
    static let transportation = "Transportation"
    static let bus = "Bus"
    static let subway = "Subway"
    static let testTaker = "Test Takers"
    static let mathScore = "Math Score"
    static let writingScore = "Writing Score"
    static let readingScore = "Critical Reading Score"
    static let na = "N/A"
    
    // Image Assets
    
    static let locationImg = "location.circle.fill"
    static let emailImg = "envelope.circle.fill"
    static let phoneImg = "phone.circle.fill"
    static let linkImg = "link.circle.fill"

    
    
    static let noDataFound = "No Data Found."
    static let noConnection = "Check your internet connection."
    static let somethingWrong = "Something went wrong."

}

struct CellIdentifiers {
    static let schoolListCell = "schoolListCell"
    
    static let infoListCell = "NYCInfoLinkCell"
    static let rightInfoCell = "NYCRightInfoCell"
    static let defaultCell = "NYCDefaultCell"
    static let textCell = "NYCTextCell"
}

struct ViewIdentifiers {
    static let detailView = "DetailView"
}
