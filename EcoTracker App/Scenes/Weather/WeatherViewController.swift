//
//  WeatherViewController.swift
//  EcoTracker App
//
//  Created by Saba Gogrichiani on 29.11.23.
//

import UIKit

final class WeatherViewController: UIViewController {
    
    // MARK: UIelements
    
    let latitudeTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .textFieldBackground
        textField.attributedPlaceholder = NSAttributedString(string: "Latitude", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)])
        textField.textColor = .textColor
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let longitudeTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.textFieldBackground
        textField.attributedPlaceholder = NSAttributedString(string: "Longitude", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)])
        textField.textColor = .textColor
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let generateWeatherButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Generate Weather", for: .normal)
        button.setTitleColor(.buttonBackground, for: .normal)
        //        button.addTarget(self, action: #selector(generateWeather), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "City: "
        label.textColor = .textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "Temperature: "
        label.textColor = .textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let weatherTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Weather Type: "
        label.textColor = .textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIsetup()
    }
    
    
    // MARK: UISetup
    
    private func UIsetup() {
        view.addSubview(latitudeTextField)
        view.addSubview(longitudeTextField)
        view.addSubview(generateWeatherButton)
        view.addSubview(stackView)
        
        stackviewSetup()
        UIConstraints()
    }
    
    private func stackviewSetup() {
        stackView.addArrangedSubview(cityLabel)
        stackView.addArrangedSubview(temperatureLabel)
        stackView.addArrangedSubview(weatherTypeLabel)
    }
    
    private func UIConstraints() {
        NSLayoutConstraint.activate([
            latitudeTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            latitudeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            latitudeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            longitudeTextField.topAnchor.constraint(equalTo: latitudeTextField.bottomAnchor, constant: 10),
            longitudeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            longitudeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            generateWeatherButton.topAnchor.constraint(equalTo: longitudeTextField.bottomAnchor, constant: 20),
            generateWeatherButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: generateWeatherButton.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
}
