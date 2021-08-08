//
//  ViewController.swift
//  NYCSchools
//
//  Created by Kalyan Boddapati on 07/08/2021.
//

import UIKit

class NYCHomeTableViewController: UITableViewController {

    var errView: ErrorView?
    var viewModel: NYCHomeViewModel!
    let search = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constants.appTitle
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.setErrorView()
        self.setUpSearchController()
        self.initializeViewModel()
    }
    
    func initializeViewModel() {
        self.viewModel = NYCHomeViewModel()
        self.viewModel.delegate = self
        self.viewModel.loadSchoolList()
    }

    func setErrorView() {
        self.errView = ErrorView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.size.height))
        self.errView!.backgroundColor = .gray
        self.tableView.addSubview(self.errView!)
        self.errView?.isHidden = true
        errView!.reloadData = {
            self.viewModel.loadSchoolList()
        }
    }
    
    func setUpSearchController() {
        search.searchBar.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = Constants.searchPlaceholder
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension NYCHomeTableViewController {
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.viewModel.cell(for: indexPath, tableView: tableView)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.viewModel.didSelect(indexPath: indexPath)
    }
    

}


extension NYCHomeTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        self.dismiss(animated: true) {
            self.viewModel.didSearch(withText: text)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.didSearchCanceled()
    }
}


extension NYCHomeTableViewController: HomeViewModelMessage {
    
    func displayError(status: Bool, message: String) {
        self.errView?.isHidden = status
        self.errView?.errorMessage = message
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func navigateTo(vc: UIViewController, type: NavigationType) {
        switch type {
        case .push:
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    func loadingIndicator(show: Bool) {
        if show {
            self.loadActivityIndicator()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
