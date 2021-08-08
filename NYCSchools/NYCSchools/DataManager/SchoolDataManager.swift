//
//  SchoolDataManager.swift
//  NYCSchools
//
//  Created by Kalyan Boddapati on 07/08/2021.
//

import Foundation
typealias SchoolDataHandler = (_ schools: [School]?,_ error: NYCError?) -> Void
typealias SATDataHandler = (_ result: SATResult?,_ error: NYCError?) -> Void
typealias NetworkHandler = (_ data: Data?, _ error: NYCError?) -> Void

class SchoolDataManager {

    var schools: [School]?

    func getAllHighSchools(_ handler: @escaping SchoolDataHandler){
        self.makeAPICall(NYSConfig.API_URL + NYSConfig.SCHOOL_API_ENDPOINT) { data, error in
            guard let data = data else {
                handler(nil, error)
                return
            }
            if let schoolList = try? JSONDecoder().decode([School].self, from: data) {
                self.schools = schoolList
                handler(schoolList, nil)
            } else {
                handler(nil, NYCError.invalidData)
            }
        }
    }
    
    func getSATInfo(for dbn: String, _ handler: @escaping SATDataHandler) {
        self.makeAPICall(NYSConfig.API_URL + NYSConfig.SAT_API_ENDPOINT,
                         ["dbn": dbn]) { data, error in
            guard let data = data else {
                handler(nil, error)
                return
            }
            if let satResult = try? JSONDecoder().decode([SATResult].self, from: data) {
                handler(satResult.first, nil)
            } else {
                handler(nil, NYCError.invalidData)
            }
        }
    }
    
    func makeAPICall(_ url: String, _ params: [String: String] = [:], _ handler: @escaping NetworkHandler) {
        guard var component = URLComponents(string: url) else {
            handler(nil, NYCError.invalidUrl)
            return
        }
        var queryItems = [URLQueryItem(name: NYSConfig.APPTOKEN_KEY, value: NYSConfig.APPTOKEN)]
        for (key, value) in params {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        component.queryItems = queryItems
        let session = URLSession.shared
        let request = URLRequest(url: component.url!)
        let task = session.dataTask(with: request,
                                    completionHandler: { data, response, networkError in
                                        if let _ = networkError {
                                            handler(nil, NYCError.networkFailed(code: (response as? HTTPURLResponse)?.statusCode ?? 400, description: networkError.debugDescription))
                                            return
                                        }
                                        
                                        guard let data = data else {
                                            handler(nil, NYCError.invalidData)
                                            return
                                        }
                                        handler(data, nil)
        })
        task.resume()
    }
}
