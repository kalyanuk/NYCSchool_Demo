//
//  SATResult.swift
//  NYCSchools
//
//  Created by Kalyan Boddapati on 07/08/2021.
//

import Foundation
struct SATResult: Codable {
    var dbn: String?
    var school_name: String?
    var num_of_sat_test_takers: String?
    var sat_critical_reading_avg_score: String?
    var sat_math_avg_score: String?
    var sat_writing_avg_score: String?
}
