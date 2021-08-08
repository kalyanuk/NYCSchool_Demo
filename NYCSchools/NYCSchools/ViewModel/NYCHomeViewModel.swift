//
//  NYCHomeViewModel.swift
//  NYCSchools
//
//  Created by Kalyan Boddapati on 07/08/2021.
//

import Foundation
import UIKit

protocol HomeViewDataFeed {
    var numberOfRows: Int {get}
    func cell(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell
    func didSelect(indexPath: IndexPath)
    func didSearch(withText text: String)
    func didSearchCanceled()
}

enum NavigationType {
    case push
    case present
}

protocol HomeViewModelMessage: class {
    func displayError(status: Bool, message: String)
    func reloadData()
    func navigateTo(vc: UIViewController, type: NavigationType)
    func loadingIndicator(show: Bool)
}

class NYCHomeViewModel: HomeViewDataFeed {
    private let dataManager = SchoolDataManager()
    private var schoolList: [School]?
    weak var delegate: HomeViewModelMessage?
    
    var numberOfRows: Int {
        return self.schoolList?.count ?? 0
    }
    
    init() {}
    
    func cell(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.schoolListCell) else {
            return UITableViewCell()
        }
        let school = self.schoolList?[indexPath.row]
        cell.textLabel?.text = school?.school_name
        cell.detailTextLabel?.text = school?.borough
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func didSelect(indexPath: IndexPath) {
        self.navigateToDetailsView(indexPath)
    }
    
    func didSearch(withText text: String) {
        if !self.validateSpaces(text: text) { return }
        self.schoolList = self.dataManager.schools?.filter({
            if let name = $0.school_name {
                return name.contains(text)
            }
            return false
        })
        self.delegate?.reloadData()
    }
    
    func didSearchCanceled() {
        self.schoolList = self.dataManager.schools
        self.delegate?.reloadData()
    }
    
    func loadSchoolList() {
        self.delegate?.loadingIndicator(show: true)
        self.dataManager.getAllHighSchools({[weak self] (list, error) in
            self?.schoolList = list
            DispatchQueue.main.async {
                self?.updateErrorMessage(error: error)
                self?.delegate?.reloadData()
                self?.delegate?.loadingIndicator(show: false)
            }
        })
    }

    /**
     Handles the error and update the error Label
     - Parameters: error -> NYSError
     - Returns: Void
     */
    func updateErrorMessage(error: NYCError?) {
        guard let err = error else {
            self.delegate?.displayError(status: true, message: Constants.noDataFound)
            return
        }
        switch err {
        case .invalidData:
            self.delegate?.displayError(status: false, message: Constants.noDataFound)
        case .invalidUrl:
            self.delegate?.displayError(status: false, message: Constants.somethingWrong)
        case .networkFailed(_, _):
            self.delegate?.displayError(status: false, message: Constants.noConnection)
        }
    }

    
    
    func navigateToDetailsView(_ indexPath: IndexPath) {
        if let selectedSchool = self.schoolList?[indexPath.row], let dbn = selectedSchool.dbn {
            self.dataManager.getSATInfo(for: dbn) { result, error in
                DispatchQueue.main.async {
                    if let detailVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: ViewIdentifiers.detailView) as? NYCDetailsTableViewController {
                        detailVC.school = selectedSchool
                        detailVC.satResult = result
                        self.delegate?.navigateTo(vc: detailVC, type: .push)
                    }
                }
            }
        }
    }
    
    /**
     Validate empty spaces and newLine
     - Parameters: text -> String
     - Returns: Bool -> return true if passed; false if failed
     */
    func validateSpaces(text: String) -> Bool {
        if text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            let alert = UIAlertController(title: "Error", message: "Please enter valid input.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.delegate?.navigateTo(vc: alert, type: .present)
            return false
        }
        return true
    }
}
