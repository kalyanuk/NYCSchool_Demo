//
//  NYCDetailsViewModel.swift
//  NYCSchools
//
//  Created by Kalyan Boddapati on 07/08/2021.
//

import Foundation
import UIKit
import MessageUI
import CoreLocation
import MapKit
import SafariServices
enum LinkType {
    case email
    case phoneNumber
    case website
    case direction
    case other(Any)
}

enum CellType {
    case text(text: String)
    case infoLink(image: String, text: String, type: LinkType)
    case rightSubTitle(title: String, subTitle: String)
    case subTitle(title: String, subTitle: String)
}

extension CellType {
    private func cellInfoLink(tableView: UITableView, atIndexPath indexPath: IndexPath) -> NYCInfoLinkCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.infoListCell, for: indexPath) as? NYCInfoLinkCell else {
            return nil
        }
        return cell
    }

    private func cellRightSubTitle(tableView: UITableView, atIndexPath indexPath: IndexPath) -> NYCRightInfoCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.rightInfoCell, for: indexPath) as? NYCRightInfoCell else {
            return nil
        }
        return cell
    }

    
    private func cellSubTitle(tableView: UITableView, atIndexPath indexPath: IndexPath) -> NYCDefaultCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.defaultCell, for: indexPath) as? NYCDefaultCell else {
            return nil
        }
        return cell
    }
    
    private func cellText(tableView: UITableView, atIndexPath indexPath: IndexPath) -> NYCTextCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.textCell, for: indexPath) as? NYCTextCell else {
            return nil
        }
        return cell
    }

}

extension CellType {
    func getCell(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        switch self {
        case .text(let text):
            if let cell = self.cellText(tableView: tableView, atIndexPath: indexPath) {
                cell.setText(text: text)
                return cell
            }
        case .infoLink(let image, let text, let type):
            if let cell = self.cellInfoLink(tableView: tableView, atIndexPath: indexPath) {
                cell.setUI(text: text, image: image, type: type)
                return cell
            }
        case .rightSubTitle(let title, let subTitle):
            if let cell = self.cellRightSubTitle(tableView: tableView, atIndexPath: indexPath) {
                cell.setUI(title: title, subTitle: subTitle)
                return cell
            }
        case .subTitle(let title, let subTitle):
            if let cell = self.cellSubTitle(tableView: tableView, atIndexPath: indexPath) {
                cell.setUI(title: title, subTitle: subTitle)
                return cell
            }
        }
        return UITableViewCell()
    }
}

protocol SectionDetails {
    var title: String { get set }
    var cells: [CellType] { get set }
    
    func trigerAction(forIndex index: Int, viewController: UIViewController)
}

struct AddressSection: SectionDetails {
    var title: String = ""
    var cells: [CellType] = []
    var school: School?
    
    init(school: School) {
        self.title = Constants.info
        self.school = school
        self.cells = [CellType.subTitle(title: school.school_name ?? "", subTitle: school.borough ?? "")]
        if self.getCompleteAddressWithoutCoordinate() != "" {
            self.cells.append(CellType.infoLink(image: Constants.locationImg, text: self.getCompleteAddressWithoutCoordinate(), type: .direction))
        }
        if let email = school.school_email,  email != "" {
            self.cells.append(CellType.infoLink(image: Constants.emailImg, text: email, type: .email))
        }
        if let phone = school.phone_number,  phone != "" {
            self.cells.append(CellType.infoLink(image: Constants.phoneImg, text: phone, type: .phoneNumber))
        }
        if let web = school.website,  web != "" {
            self.cells.append(CellType.infoLink(image: Constants.linkImg, text: web, type: .website))
        }
    }
    
    /// - Returns: Stirng, address of the high school
    func getCompleteAddressWithoutCoordinate() -> String{
        if let schoolAddress = self.school?.location {
            let address = schoolAddress.components(separatedBy: "(")
            return address[0]
        }
        return ""
    }
    
    /// This function will fetch the coodinates for the selected High School location
    ///
    /// - Returns: CLLocationCoordinate2D, coodinate of High School location
    func getCoodinateForSchool() -> CLLocationCoordinate2D?{
        if let schoolAddress = self.school?.location {
            let coordinateString = schoolAddress.slice(from: "(", to: ")")
            let coordinates = coordinateString?.components(separatedBy: ",")
            if let coordinateArray = coordinates{
                let latitude = (coordinateArray[0] as NSString).doubleValue
                let longitude = (coordinateArray[1] as NSString).doubleValue
                return CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
            }
        }
        return nil
    }

    func formattedWebSite() -> String {
        guard let site = self.school?.website?.trimmingCharacters(in: .whitespacesAndNewlines) else { return "" }
        if site.hasPrefix("http") {
            return site
        } else {
            return "http://"+site
        }
    }
    
    func formattedPhoneNumber() -> String {
        guard let phoneNumber = self.school?.phone_number else { return "" }
        return phoneNumber.replacingOccurrences(of: "-", with: "")
    }
    
    func trigerAction(forIndex index: Int, viewController: UIViewController) {
        if case CellType.infoLink(_ , _, let type) = cells[index] {
            switch type{
            case .email:
                self.sendEmail(self.school?.school_email, viewController)
                break
            case .phoneNumber:
                self.makeAPhoneCall(self.formattedPhoneNumber())
                break
            case .website:
                self.showWebsite(self.formattedWebSite(), viewController)
                break
            case .direction:
                self.showDirection()
            default: break
            }
        }
    }

    func sendEmail(_ email: String?, _ vc: UIViewController)  {
        guard let email = email else {
            return
        }
        // Show default mail composer
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = vc as? MFMailComposeViewControllerDelegate
            mail.setToRecipients([email])
            vc.present(mail, animated: true)
        
        // Show third party email composer if default Mail app is not present
        } else if let emailUrl = createEmailUrl(to: email) {
            UIApplication.shared.open(emailUrl)
        }
    }
    
    func showWebsite(_ link: String, _ vc: UIViewController) {
        if let url = URL(string: link) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let sf = SFSafariViewController(url: url, configuration: config)
            vc.present(sf, animated: true)
        }
    }

    func makeAPhoneCall(_ phone: String)  {
        if let phoneCallURL = URL(string: "tel:\(phone)") {
            UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
        }
    }
    
    func showDirection() {
        if let coordinate = getCoodinateForSchool() {
            // Open and show coordinate
            let url = "http://maps.apple.com/maps?saddr=\(coordinate.latitude),\(coordinate.longitude)"
            if let url = URL(string:url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }

    }

    private func createEmailUrl(to: String) -> URL? {
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)")
        let defaultUrl = URL(string: "mailto:\(to)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        return defaultUrl
    }

}



struct SATSection: SectionDetails {
    var title: String = ""
    var cells: [CellType] = []
    
    init(satResult: SATResult) {
        self.title = Constants.satResults
        self.cells = [
            CellType.rightSubTitle(title: Constants.testTaker, subTitle: satResult.num_of_sat_test_takers ?? Constants.na),
            CellType.rightSubTitle(title: Constants.mathScore, subTitle: satResult.sat_math_avg_score ?? Constants.na),
            CellType.rightSubTitle(title: Constants.writingScore, subTitle: satResult.sat_writing_avg_score ?? Constants.na),
            CellType.rightSubTitle(title: Constants.readingScore, subTitle: satResult.sat_critical_reading_avg_score ?? Constants.na),
                ]
    }
    
    func trigerAction(forIndex index: Int, viewController: UIViewController) {}
}


struct OverviewSection: SectionDetails {
    var title: String = ""
    var cells: [CellType] = []
    init(school: School) {
        self.title = Constants.overview
        self.cells = [
            CellType.text(text: school.overview_paragraph ?? ""),
                ]
    }
    func trigerAction(forIndex index: Int, viewController: UIViewController) {}
}

struct TransportationSection: SectionDetails {
    var title: String = ""
    var cells: [CellType] = []

    init(school: School) {
        self.title = Constants.transportation
        self.cells = [
            CellType.subTitle(title: Constants.bus, subTitle: school.bus ?? ""),
            CellType.subTitle(title: Constants.subway, subTitle: school.subway ?? ""),
                ]
    }
    
    func trigerAction(forIndex index: Int, viewController: UIViewController) {}
}
