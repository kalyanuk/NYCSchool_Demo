//
//  NYCError.swift
//  NYCSchools
//
//  Created by Kalyan Boddapati on 07/08/2021.
//

import Foundation
enum NYCError: Error {
    case invalidUrl
    case networkFailed(code: Int, description: String)
    case invalidData
}
