//
//  WeatherDetailViewController.swift
//  WeatherApp
//
//  Created by Seren Sencer on 20.06.2019.
//  Copyright © 2019 Seren Sencer. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    
    let API_KEY = "ed0673cf4a3e6419e72d43ba4096200d"
    let URL_FOR_FORECAST = "http://api.openweathermap.org/data/2.5/forecast"
    
    let MINIMUM_LINE_SPACING: CGFloat = 30
    let NUMBER_OF_COLLECTION_VIEW_ITEMS: CGFloat = 12
    let COLLECTION_VIEW_ITEM_WIDTH: CGFloat = 50
    let COLLECTION_VIEW_ITEM_HEIGHT: CGFloat = 120
    
    let weatherForecastCollectionCellIdentifier = "weatherViewCell"
    
    var currentCityId: String?
    var currentWeather: WeatherResponse.Element?
    var forecastList: [WeatherResponse.Element]?
    
    var detailView: WeatherDetailView!
    var weatherForecastView: UICollectionView!
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let mainStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 10
        return view
    }()
    
    lazy var spinnerView: UIActivityIndicatorView = {
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
    
    let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
    
    override func loadView() {
        super.loadView()
        
        navigationItem.title = ""
        
        view.backgroundColor = #colorLiteral(red: 0.2426472604, green: 0.7646625638, blue: 0.8370514512, alpha: 1)
        
        view.addSubview(spinnerView)
        spinnerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinnerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        view.addSubview(scrollView)
        scrollView.addSubview(mainStackView)

        if #available(iOS 11.0, *) {
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            mainStackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -10).isActive = true
        } else {
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            scrollView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true
            mainStackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true
        }
        
        mainStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 5).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -5).isActive = true
        mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -5).isActive = true
        
        detailView = WeatherDetailView()
        detailView.weather = currentWeather
        mainStackView.addArrangedSubview(detailView)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        flowLayout.itemSize = CGSize(width: COLLECTION_VIEW_ITEM_WIDTH, height: COLLECTION_VIEW_ITEM_HEIGHT)
        flowLayout.minimumLineSpacing = calculateLineSpacing()
        weatherForecastView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        mainStackView.addArrangedSubview(weatherForecastView)
        
        weatherForecastView.dataSource = self
        weatherForecastView.delegate = self
        weatherForecastView.register(WeatherForecastCollectionViewCell.self, forCellWithReuseIdentifier: weatherForecastCollectionCellIdentifier)
        
        weatherForecastView.translatesAutoresizingMaskIntoConstraints = false
        weatherForecastView.heightAnchor.constraint(equalToConstant: CGFloat(COLLECTION_VIEW_ITEM_HEIGHT + 10)).isActive = true
        weatherForecastView.backgroundColor = .clear
        weatherForecastView.layer.borderWidth = 1
        weatherForecastView.layer.borderColor = #colorLiteral(red: 0.7381528249, green: 0.9663144246, blue: 0.9580431986, alpha: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTableDetails()
    }
        
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        detailView.orientation = UIDevice.current.orientation
        
        guard let layout = weatherForecastView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        layout.minimumLineSpacing = calculateLineSpacing()
        layout.invalidateLayout()
    }
    
    private func calculateLineSpacing() -> CGFloat {
        let allItemsWidth = COLLECTION_VIEW_ITEM_WIDTH*NUMBER_OF_COLLECTION_VIEW_ITEMS
        let widthForSpacing = view.frame.width - allItemsWidth - 30
        if widthForSpacing > MINIMUM_LINE_SPACING*(NUMBER_OF_COLLECTION_VIEW_ITEMS-1) {
            return widthForSpacing / (NUMBER_OF_COLLECTION_VIEW_ITEMS-1)
        } else {
            return MINIMUM_LINE_SPACING
        }
    }
    
    private func loadTableDetails() {
        view.bringSubviewToFront(spinnerView)
        mainStackView.isHidden = true
        spinnerView.isHidden = false
        spinnerView.startAnimating()
        
        let urlStr = URL_FOR_FORECAST
        let apiKey = API_KEY
        var items = [URLQueryItem]()
        guard var urlComponents = URLComponents(string: urlStr) else {
            present(errorAlert, animated: true)
            return
        }
        let param = ["id":currentCityId,"appid":apiKey, "units":"metric"]
        for (key,value) in param {
            items.append(URLQueryItem(name: key, value: value))
        }
        urlComponents.queryItems = items
        guard let url = urlComponents.url else {
            present(errorAlert, animated: true)
            return
        }
        
        APIManager.request(url: url, completion: { data, error in
            self.spinnerView.stopAnimating()
            self.spinnerView.isHidden = true
            self.mainStackView.isHidden = false
            
            if error != nil {
                self.present(self.errorAlert, animated: true)
                return
            }
            
            if let data = data {
                do {
                    let decodedData = try self.jsonDecoder.decode(WeatherResponse.self, from: data)
                    if let list = decodedData.list {
                        self.forecastList = list
                        self.weatherForecastView.reloadData()
                    }
                } catch {
                    self.present(self.errorAlert, animated: true)
                    print("###### ERROR: JSON Decoder ######")
                    print(error)
                    return
                }
            }
        })
    }
}

extension WeatherDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if forecastList?.count != nil {
            return Int(NUMBER_OF_COLLECTION_VIEW_ITEMS)
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: weatherForecastCollectionCellIdentifier, for: indexPath) as! WeatherForecastCollectionViewCell
        cell.weather = forecastList?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("item selected \(indexPath.row)")
    }
    
}
