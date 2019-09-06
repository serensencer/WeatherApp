//
//  WeatherDetailView.swift
//  WeatherApp
//
//  Created by Seren Sencer on 20.06.2019.
//  Copyright © 2019 Seren Sencer. All rights reserved.
//

import UIKit

class WeatherDetailView: UIView {
    
    var orientation: UIDeviceOrientation! {
        didSet {
            if orientation.isLandscape {
                minMaxTempHumidityCloudStackView.axis = .horizontal
                windSunriseSunsetStackView.axis = .horizontal
            } else {
                minMaxTempHumidityCloudStackView.axis = .vertical
                windSunriseSunsetStackView.axis = .vertical
            }
        }
    }
    
    var weather: WeatherResponse.Element? {
        didSet {
            guard let weatherItem = weather else {return}
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            if let cityName = weatherItem.name {
                cityNameLabel.text = cityName
            }
            if let description = weatherItem.weather?.first?.description {
                desctiptionLabel.text = "Right Now\n\(description)"
            }
            if let temperature = weatherItem.main?.temp {
                weatherTemperatureLabel.text = String(format: "%.0f", temperature) + " °C "
            }
            if let icon = weatherItem.weather?.first?.icon {
                weatherIcon.image = UIImage(named: icon)
            }
            if let sunrise = weatherItem.sys?.sunrise {
                let dateStr = dateFormatter.string(from: sunrise)
                sunriseValueLabel.text = "\(dateStr)"
            }
            if let sunset = weatherItem.sys?.sunset {
                let dateStr = dateFormatter.string(from: sunset)
                sunsetValueLabel.text = "\(dateStr)"
            }
            if let maxTemp = weatherItem.main?.tempMax {
                maxTempDegreeLabel.text = String(format: "%.0f", maxTemp) + " °C"
            }
            if let minTemp = weatherItem.main?.tempMin {
                minTempDegreeLabel.text = String(format: "%.0f", minTemp) + " °C"
            }
            if let humidity = weatherItem.main?.humidity {
                humidityValueLabel.text = String(humidity) + "%"
            }
            if let cloudiness = weatherItem.clouds?.all {
                cloudinessValueLabel.text = String(cloudiness) + "%"
            }
            if let windSpeed = weatherItem.wind?.speed {
                windSpeedValueLabel.text = String(windSpeed) + " m/s"
            }
            if let windDirection = weatherItem.wind?.deg {
                windDirectionDegreeLabel.text = String(windDirection) + " °"
            }
        }
    }
    
    let mainStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fill
        view.spacing = 10
        view.axis = .vertical
        return view
    }()
    
    let cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.textColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let weatherIcon: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 10
        return img
    }()
    
    let desctiptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    let weatherTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 38)
        label.textColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let rightNowStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .equalSpacing
        return view
    }()
    
    let cityStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layoutMargins = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 0)
        view.isLayoutMarginsRelativeArrangement = true
        view.axis = .vertical
        view.addBorder(color: #colorLiteral(red: 0.7381528249, green: 0.9663144246, blue: 0.9580431986, alpha: 1))
        return view
    }()
    
    let minTempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "MIN TEMP"
        return label
    }()
    
    let minTempDegreeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let minTempStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()
    
    let maxTempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "MAX TEMP"
        label.textAlignment = .right
        return label
    }()
    
    let maxTempDegreeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    let maxTempStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()
    
    let minMaxTempStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .equalCentering
        view.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        view.isLayoutMarginsRelativeArrangement = true
        view.addBorder(color: #colorLiteral(red: 0.7381528249, green: 0.9663144246, blue: 0.9580431986, alpha: 1))
        return view
    }()
    
    let humidityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "HUMIDITY"
        return label
    }()
    
    let humidityValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let humidityStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()
    
    let cloudinessLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "CLOUDINESS"
        label.textAlignment = .right
        return label
    }()
    
    let cloudinessValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    let cloudinessStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()
    
    let humidityCloudStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .equalCentering
        view.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        view.isLayoutMarginsRelativeArrangement = true
        view.addBorder(color: #colorLiteral(red: 0.7381528249, green: 0.9663144246, blue: 0.9580431986, alpha: 1))
        return view
    }()
    
    let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "WIND SPEED"
        return label
    }()
    
    let windSpeedValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let windSpeedStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()
    
    let windDirectionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "WIND DIRECTION"
        label.textAlignment = .right
        return label
    }()
    
    let windDirectionDegreeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.text = " "
        return label
    }()
    
    let windDirectionStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()
    
    let windStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .equalCentering
        view.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        view.isLayoutMarginsRelativeArrangement = true
        view.addBorder(color: #colorLiteral(red: 0.7381528249, green: 0.9663144246, blue: 0.9580431986, alpha: 1))
        return view
    }()
    
    let sunriseLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "SUNRISE"
        return label
    }()
    
    let sunriseValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sunriseStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()
    
    let sunsetLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "SUNSET"
        label.textAlignment = .right
        return label
    }()
    
    let sunsetValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    let sunsetStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()
    
    let sunriseSunsetStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .equalCentering
        view.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        view.isLayoutMarginsRelativeArrangement = true
        view.addBorder(color: #colorLiteral(red: 0.7381528249, green: 0.9663144246, blue: 0.9580431986, alpha: 1))
        return view
    }()
    
    let minMaxTempHumidityCloudStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fillEqually
        view.spacing = 10
        if UIDevice.current.orientation.isLandscape {
            view.axis = .horizontal
        } else {
            view.axis = .vertical
        }
        return view
    }()
    
    let windSunriseSunsetStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fillEqually
        view.spacing = 10
        if UIDevice.current.orientation.isLandscape {
            view.axis = .horizontal
        } else {
            view.axis = .vertical
        }
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        rightNowStackView.addArrangedSubview(weatherIcon)
        rightNowStackView.addArrangedSubview(desctiptionLabel)
        rightNowStackView.addArrangedSubview(weatherTemperatureLabel)
        
        cityStackView.addArrangedSubview(cityNameLabel)
        cityStackView.addArrangedSubview(rightNowStackView)
        
        minTempStackView.addArrangedSubview(minTempLabel)
        minTempStackView.addArrangedSubview(minTempDegreeLabel)
        maxTempStackView.addArrangedSubview(maxTempLabel)
        maxTempStackView.addArrangedSubview(maxTempDegreeLabel)
        minMaxTempStackView.addArrangedSubview(minTempStackView)
        minMaxTempStackView.addArrangedSubview(maxTempStackView)
        
        humidityStackView.addArrangedSubview(humidityLabel)
        humidityStackView.addArrangedSubview(humidityValueLabel)
        cloudinessStackView.addArrangedSubview(cloudinessLabel)
        cloudinessStackView.addArrangedSubview(cloudinessValueLabel)
        humidityCloudStackView.addArrangedSubview(humidityStackView)
        humidityCloudStackView.addArrangedSubview(cloudinessStackView)
        
        windSpeedStackView.addArrangedSubview(windSpeedLabel)
        windSpeedStackView.addArrangedSubview(windSpeedValueLabel)
        windDirectionStackView.addArrangedSubview(windDirectionLabel)
        windDirectionStackView.addArrangedSubview(windDirectionDegreeLabel)
        windStackView.addArrangedSubview(windSpeedStackView)
        windStackView.addArrangedSubview(windDirectionStackView)
        
        sunriseStackView.addArrangedSubview(sunriseLabel)
        sunriseStackView.addArrangedSubview(sunriseValueLabel)
        sunsetStackView.addArrangedSubview(sunsetLabel)
        sunsetStackView.addArrangedSubview(sunsetValueLabel)
        sunriseSunsetStackView.addArrangedSubview(sunriseStackView)
        sunriseSunsetStackView.addArrangedSubview(sunsetStackView)
        
        minMaxTempHumidityCloudStackView.addArrangedSubview(minMaxTempStackView)
        minMaxTempHumidityCloudStackView.addArrangedSubview(humidityCloudStackView)
        
        windSunriseSunsetStackView.addArrangedSubview(windStackView)
        windSunriseSunsetStackView.addArrangedSubview(sunriseSunsetStackView)
        
        mainStackView.addArrangedSubview(cityStackView)
        mainStackView.addArrangedSubview(minMaxTempHumidityCloudStackView)
        mainStackView.addArrangedSubview(windSunriseSunsetStackView)

        self.addSubview(mainStackView)
        
        mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        mainStackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension UIStackView {
    func addBorder(color: CGColor) {
        let subView = UIView(frame: bounds)
        subView.layer.borderColor = color
        subView.layer.borderWidth = 1
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
