//
//  CityViewController.swift
//  WeatherApp
//
//  Created by Seren Sencer on 17.06.2019.
//  Copyright © 2019 Seren Sencer. All rights reserved.
//

import UIKit

protocol CityViewDelegate: class {
    func didSelectCity(_ cityViewController: CityViewController, _ cityId: String?)
}

class CityViewController: UIViewController {
    
    let cityListTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = #colorLiteral(red: 0.2426472604, green: 0.7646625638, blue: 0.8370514512, alpha: 1)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var cityList: [City] = []
    
    var filteredCityList: [City] = []
    
    var resultSearchController: UISearchController!
    
    weak var delegate: CityViewDelegate?
    
    var previousSearch: String = ""
    
    override func loadView() {
        super.loadView()
        
        navigationItem.title = "Add City"
        
        view.addSubview(cityListTableView)
        view.backgroundColor = #colorLiteral(red: 0.2426472604, green: 0.7646625638, blue: 0.8370514512, alpha: 1)
        
        cityListTableView.delegate = self
        cityListTableView.dataSource = self
        cityListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cityCell")
        
        if #available(iOS 11.0, *) {
            cityListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            cityListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            cityListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            cityListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            cityListTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            cityListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            cityListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            cityListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultSearchController = UISearchController(searchResultsController: nil)
        resultSearchController.searchResultsUpdater = self
        resultSearchController.searchBar.placeholder = "Search Cities"
        resultSearchController.searchBar.sizeToFit()
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        extendedLayoutIncludesOpaqueBars = true

        if #available(iOS 11.0, *) {
            navigationItem.searchController = resultSearchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            cityListTableView.tableHeaderView = resultSearchController.searchBar
        }
    }
    
}

extension CityViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredCityList.count == 0 {
            tableView.setEmptyView(message: "Type a city name above ...")
        } else {
            tableView.restore()
        }
        return filteredCityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        cell.textLabel?.text = filteredCityList[indexPath.row].name!
        cell.textLabel?.textColor = .white
        cell.backgroundColor = #colorLiteral(red: 0.2426472604, green: 0.7646625638, blue: 0.8370514512, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addedCity = filteredCityList[indexPath.row]
        if addedCity.id != nil {
            let addedCityId = String(addedCity.id!)
            delegate?.didSelectCity(self, addedCityId)
        }
    }
}

extension CityViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        DispatchQueue.global(qos: .userInitiated).async {
            if searchText == "" {
                self.filteredCityList = []
            } else {
                if searchText.contains(self.previousSearch) {
                    self.filteredCityList = (self.filteredCityList.filter { $0.name?.range(of: searchText, options: [.caseInsensitive]) != nil })
                } else {
                    self.filteredCityList.removeAll(keepingCapacity: false)
                    self.filteredCityList = (self.cityList.filter { $0.name?.range(of: searchText, options: [.caseInsensitive]) != nil })
                }
                self.previousSearch = searchText
            }
            DispatchQueue.main.async {
                self.cityListTableView.reloadData()
            }
        }
    }
}

extension UITableView {
    
    func setEmptyView(message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let messageLabel = UILabel()
        
        emptyView.addSubview(messageLabel)
        self.backgroundView = emptyView

        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = UIColor.white
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        if let headerView = self.tableHeaderView {
            messageLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 5).isActive = true
        } else {
            messageLabel.topAnchor.constraint(equalTo: emptyView.topAnchor, constant: 5).isActive = true
        }
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
