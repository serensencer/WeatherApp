//
//  WeatherListTableViewCell.swift
//  WeatherApp
//
//  Created by Seren Sencer on 12.06.2019.
//  Copyright © 2019 Seren Sencer. All rights reserved.
//

import UIKit

class WeatherListTableViewCell : UITableViewCell {
    
    var weather: WeatherResponse.Element? {
        didSet {
            guard let weatherItem = weather else {return}
            if let cityName = weatherItem.name {
                cityNameLabel.text = "\(cityName)"
            }
            if let temperature = weatherItem.main?.temp {
                weatherTemperatureLabel.text = String(format: "%.0f", temperature) + " °C"
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
    
    let cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = _ColorLiteralType(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let weatherTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = _ColorLiteralType(red: 1, green: 1, blue: 1, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cityAndTempStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .equalSpacing
        view.axis = .vertical
        return view
    }()
    
    let tableCellStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layoutMargins = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        view.distribution = .equalCentering
        view.alignment = .center
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        contentView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        contentView.addSubview(tableCellStackView)
        
        tableCellStackView.addArrangedSubview(cityAndTempStackView)
        tableCellStackView.addArrangedSubview(weatherIcon)
        
        cityAndTempStackView.addArrangedSubview(cityNameLabel)
        cityAndTempStackView.addArrangedSubview(weatherTemperatureLabel)
        
        tableCellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        tableCellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        tableCellStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        tableCellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
