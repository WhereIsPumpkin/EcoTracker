//
//  WeatherViewController.swift
//  EcoTracker App
//
//  Created by Saba Gogrichiani on 29.11.23.
//

import UIKit

final class WeatherViewController: UIViewController {
    
    
    // MARK: UIelements
    
    let viewModel = WeatherViewModel()
    
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
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        label.textColor = .componentAccent
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .textColor
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 40, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let weatherTypeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .textColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIsetup()
        setupButton()
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
    private func setupButton() {
            generateWeatherButton.addTarget(self, action: #selector(generateWeatherButtonTapped), for: .touchUpInside)
        }

        @objc private func generateWeatherButtonTapped() {
            guard let latitudeText = latitudeTextField.text,
                  let longitudeText = longitudeTextField.text,
                  let latitude = Double(latitudeText),
                  let longitude = Double(longitudeText) else {
                return
            }

            viewModel.getWeather(latitude: latitude, longitude: longitude) { [weak self] result in
                switch result {
                case .success(let weatherData):
                    self?.updateUI(with: weatherData)
                case .failure(let error):
                    print("Error fetching weather data: \(error)")
                }
            }
        }

        private func updateUI(with weatherData: WeatherData) {
            cityLabel.text = weatherData.city.name
            temperatureLabel.text = "\(weatherData.list.first?.main.temp ?? 0) °C"
            weatherTypeLabel.text = weatherData.list.first?.weather.first?.description
        }
}


