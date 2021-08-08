//
//  NYCDetailsTableViewController.swift
//  NYCSchools
//
//  Created by Kalyan Boddapati on 07/08/2021.
//

import Foundation
import MessageUI

class NYCDetailsTableViewController: UITableViewController {

    var school: School?
    var satResult: SATResult?
    var sections: [SectionDetails] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constants.detailsTitle
        if let school = school {
            sections.append(AddressSection(school: school))
            if let satResult = satResult {
                sections.append(SATSection(satResult: satResult))
            }
            sections.append(OverviewSection(school: school))
            sections.append(TransportationSection(school: school))
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sections[section].cells.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sections[indexPath.section].cells[indexPath.row].getCell(tableView: tableView, atIndexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        sections[indexPath.section].trigerAction(forIndex: indexPath.row, viewController: self)
    }
}

extension NYCDetailsTableViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

}
