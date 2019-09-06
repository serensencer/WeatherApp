//
//  WeatherForecastCollectionViewCell.swift
//  WeatherApp
//
//  Created by Seren Sencer on 24.06.2019.
//  Copyright © 2019 Seren Sencer. All rights reserved.
//

import UIKit

class WeatherForecastCollectionViewCell: UICollectionViewCell {
    
    var weather: WeatherResponse.Element? {
        didSet {
            guard let weatherItem = weather else {return}
            if let temperature = weatherItem.main?.temp {
                weatherTemperatureLabel.text = String(format: "%.0f", temperature) + " °C"
            }
            if let time = weatherItem.dt {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                let dateStr = dateFormatter.string(from: time)
                timeLabel.text = "\(dateStr)"
            }
            if let icon = weatherItem.weather?.first?.icon {
                weatherIcon.image = UIImage(named: icon)
            }
        }
    }
    
    let weatherIcon: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 10
        return img
    }()
    
    let weatherTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor =  _ColorLiteralType(red: 1, green: 1, blue: 1, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor =  _ColorLiteralType(red: 1, green: 1, blue: 1, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cellStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 10
        view.distribution = .equalCentering
        view.axis = .vertical
        view.alignment = .center
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(cellStackView)
        
        weatherIcon.widthAnchor.constraint(equalToConstant: 30)
        weatherIcon.heightAnchor.constraint(equalToConstant: 30)

        cellStackView.addArrangedSubview(timeLabel)
        cellStackView.addArrangedSubview(weatherTemperatureLabel)
        cellStackView.addArrangedSubview(weatherIcon)
        
        cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
    }
    
}
