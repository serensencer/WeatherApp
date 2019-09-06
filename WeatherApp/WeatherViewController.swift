//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Seren Sencer on 10.06.2019.
//  Copyright © 2019 Seren Sencer. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    let API_KEY = "ed0673cf4a3e6419e72d43ba4096200d"
    let URL_FOR_MULTIPLE_CITIES = "http://api.openweathermap.org/data/2.5/group"
    
    let weatherCellIdentifier = "weatherCell"
    let userDefaultsCityIdListKey = "userCityIdList"
    
    var weatherList: [WeatherResponse.Element] = [] {
        didSet {
            weatherListTableView.reloadData()
        }
    }
    
    var userCityIdList: [String] = []
    
    var userDefaults: UserDefaults = .standard
    
    var cityList: [City] = []
    
    var isCityListLoaded = false
    
    let cityListLoadDispatchGroup = DispatchGroup()
    
    var cityListViewController: CityViewController!
    
    var barButtonItem: UIBarButtonItem!
    
    let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
    
    var spinnerView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    lazy var errorAlert: UIAlertController = {
        let alert = UIAlertController(title: "Error!", message: "An unknown error occured, please restart the WheatherApp.", preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: {action in
            alert.dismiss(animated: true)
        }))
        return alert
    }()
    
    lazy var existingCityAlert: UIAlertController = {
        let alert = UIAlertController(title: "", message: "Selected city is already in your list.", preferredStyle: .actionSheet)
        alert.addAction(.init(title: "OK", style: .default, handler: {action in
            alert.dismiss(animated: true)
        }))
        return alert
    }()
    
    let weatherListTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = #colorLiteral(red: 0.2426472604, green: 0.7646625638, blue: 0.8370514512, alpha: 1)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        return tableView
    }()
    
    let emptyTableLabelView: UILabel = {
        let label = UILabel()
        label.text = "You can add a new city by pressing + button."
        label.numberOfLines = 0
        label.textColor = .white
        label.backgroundColor = #colorLiteral(red: 0.2426472604, green: 0.7646625638, blue: 0.8370514512, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = #colorLiteral(red: 0.2426472604, green: 0.7646625638, blue: 0.8370514512, alpha: 1)
        weatherListTableView.dataSource = self
        weatherListTableView.delegate = self
        
        view.addSubview(spinnerView)
        view.addSubview(weatherListTableView)
        view.addSubview(emptyTableLabelView)
        
        barButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addNewItem(sender:)))
        setUpNavigation()
        
        if #available(iOS 11.0, *) {
            weatherListTableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
            weatherListTableView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            weatherListTableView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            weatherListTableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            weatherListTableView.topAnchor.constraint(equalTo:self.topLayoutGuide.bottomAnchor).isActive = true
            weatherListTableView.leadingAnchor.constraint(equalTo:view.leadingAnchor).isActive = true
            weatherListTableView.trailingAnchor.constraint(equalTo:view.trailingAnchor).isActive = true
            weatherListTableView.bottomAnchor.constraint(equalTo:self.bottomLayoutGuide.topAnchor).isActive = true
        }
        
        weatherListTableView.register(WeatherListTableViewCell.self, forCellReuseIdentifier: weatherCellIdentifier)
        
        emptyTableLabelView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyTableLabelView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        spinnerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinnerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readCityListFromFile()
        
        loadWeatherTableView()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        weatherListTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    private func readCityListFromFile(){
        DispatchQueue.global(qos: .background).async {
            do {
                self.cityListLoadDispatchGroup.enter()
                let path: NSString = Bundle.main.path(forResource: "cityList", ofType: "json")! as NSString
                let data: NSData = try NSData(contentsOfFile: path as String, options: NSData.ReadingOptions.dataReadingMapped)
                let jsonDecoder = JSONDecoder()
                let plistData = try jsonDecoder.decode([City].self, from: data as Data)
                self.cityList = plistData
                self.isCityListLoaded = true
                self.cityListLoadDispatchGroup.leave()
            } catch {
                print("###### ERROR: City List loading failed. ######")
            }
        }
    }
    
    private func setUpNavigation() {
        navigationItem.title = "WeatherApp"
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2426472604, green: 0.7646625638, blue: 0.8370514512, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:_ColorLiteralType(red: 1, green: 1, blue: 1, alpha: 1)]
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc func addNewItem(sender: UIBarButtonItem) {
        if !isCityListLoaded {
            navigationItem.rightBarButtonItem = nil
            
            weatherListTableView.isHidden = true
            emptyTableLabelView.isHidden = true
            spinnerView.isHidden = false
            spinnerView.startAnimating()
            
            cityListLoadDispatchGroup.notify(queue: DispatchQueue.main) {
                self.spinnerView.stopAnimating()
                self.spinnerView.isHidden = true
                if self.userCityIdList.count == 0 {
                    self.emptyTableLabelView.isHidden = false
                } else {
                    self.weatherListTableView.isHidden = false
                }
                self.openCityViewController()
            }
        } else {
            openCityViewController()
        }
        
    }
    
    private func openCityViewController() {
        cityListViewController = CityViewController()
        cityListViewController.delegate = self
        cityListViewController.cityList = cityList
        navigationController?.pushViewController(self.cityListViewController, animated: true)
    }
    
    private func loadWeatherTableView() {
        userCityIdList = userDefaults.array(forKey: userDefaultsCityIdListKey) as? [String] ?? [String]()
        if userCityIdList.isEmpty {
            emptyTableLabelView.isHidden = false
            weatherListTableView.isHidden = true
            spinnerView.isHidden = true
        } else {
            emptyTableLabelView.isHidden = true
            weatherListTableView.isHidden = true
            spinnerView.isHidden = false
            spinnerView.startAnimating()
            
            let urlStr = URL_FOR_MULTIPLE_CITIES
            let apiKey = API_KEY
            var items = [URLQueryItem]()
            guard var urlComponents = URLComponents(string: urlStr) else {
                present(errorAlert, animated: true)
                print("###### ERROR: URLComponents ######")
                return
            }
            let cityIdListUrlParam: String = userCityIdList.joined(separator: ",")
            let param = ["id":cityIdListUrlParam,"appid":apiKey, "units":"metric"]
            for (key,value) in param {
                items.append(URLQueryItem(name: key, value: value))
            }
            urlComponents.queryItems = items
            guard let url = urlComponents.url else {
                present(errorAlert, animated: true)
                print("###### ERROR: URLComponents.url ######")
                return
            }
            
            APIManager.request(url: url, completion: { data, error in
                self.spinnerView.stopAnimating()
                self.spinnerView.isHidden = true
                
                if error != nil {
                    self.present(self.errorAlert, animated: true)
                    print("###### ERROR: Server ######")
                    print(error!)
                    return
                }
                
                if let data = data {
                    do {
                        let decodedData = try self.jsonDecoder.decode(WeatherResponse.self, from: data)
                        if let list = decodedData.list {
                            self.weatherList =  list
                            self.weatherListTableView.isHidden = false
                            self.weatherListTableView.reloadData()
                        }
                    } catch {
                        self.present(self.errorAlert, animated: true)
                        print("###### ERROR: Decoder ######")
                        print(error)
                        return
                    }
                }
            })
        }
    }
    
}

extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return weatherList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: weatherCellIdentifier, for: indexPath) as! WeatherListTableViewCell
        cell.weather = weatherList[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.layer.backgroundColor = #colorLiteral(red: 0.2426472604, green: 0.7646625638, blue: 0.8370514512, alpha: 1)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cityId = weatherList[indexPath.section].id {
            let weatherDetailViewController = WeatherDetailViewController()
            weatherDetailViewController.currentCityId = String(cityId)
            weatherDetailViewController.currentWeather = weatherList[indexPath.section]
            self.navigationController?.pushViewController(weatherDetailViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if let id = weatherList[indexPath.section].id {
                userCityIdList = userCityIdList.filter{ $0 != String(id)}
                userDefaults.set(userCityIdList, forKey: userDefaultsCityIdListKey)
                weatherList.remove(at: indexPath.section)
                if weatherList.count == 0 {
                    loadWeatherTableView()
                }
            }
        }
    }
}

extension WeatherViewController: CityViewDelegate {
    func didSelectCity(_ cityViewController: CityViewController, _ cityId: String?) {
        navigationController?.popViewController(animated: true)
        if let addedCityId = cityId {
            if !userCityIdList.contains(addedCityId) {
                userCityIdList.append(addedCityId)
                userDefaults.set(userCityIdList, forKey: userDefaultsCityIdListKey)
                loadWeatherTableView()
            } else {
                navigationController?.popViewController(animated: true)
                if let popoverController = self.existingCityAlert.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                }
                present(self.existingCityAlert, animated: true)
            }
        }
    }
}
