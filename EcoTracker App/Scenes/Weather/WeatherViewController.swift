//
//  WeatherViewController.swift
//  EcoTracker App
//
//  Created by Saba Gogrichiani on 29.11.23.
//

import UIKit

final class WeatherViewController: UIViewController, WeatherViewDelegate {
    
    private let viewModel = WeatherViewModel()
    
    // MARK: UIelements
    
    private let latitudeTextField = UITextField()
    private let longitudeTextField = UITextField()
    private let generateWeatherButton = UIButton()
    private let cityLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let weatherTypeLabel = UILabel()
    private let stackView = UIStackView()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIsetup()
        elementsSetup()
        setupButton()
        viewModel.delegate = self
    }
    
    
    // MARK: UISetup
    
    private func UIsetup() {
        view.addSubview(latitudeTextField)
        view.addSubview(longitudeTextField)
        view.addSubview(generateWeatherButton)
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(cityLabel)
        stackView.addArrangedSubview(temperatureLabel)
        stackView.addArrangedSubview(weatherTypeLabel)
        
        UIConstraints()
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
    
    // MARK: ElementsSetup
    private func elementsSetup() {
        latitudeTextFieldSetup()
        longitudeTextFieldSetup()
        generateWeatherButtonSetup()
        cityLabelSetup()
        temperatureLabelSetup()
        weatherTypeLabelSetup()
        stackViewSetup()
    }
    
    private func latitudeTextFieldSetup() {
        latitudeTextField.backgroundColor = .textFieldBackground
        latitudeTextField.attributedPlaceholder = NSAttributedString(string: "Latitude", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)])
        latitudeTextField.textColor = .textColor
        latitudeTextField.borderStyle = .roundedRect
        latitudeTextField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func longitudeTextFieldSetup() {
        longitudeTextField.backgroundColor = UIColor.textFieldBackground
        longitudeTextField.attributedPlaceholder = NSAttributedString(string: "Longitude", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)])
        longitudeTextField.textColor = .textColor
        longitudeTextField.borderStyle = .roundedRect
        longitudeTextField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func generateWeatherButtonSetup () {
        generateWeatherButton.setTitle("Generate Weather", for: .normal)
        generateWeatherButton.setTitleColor(.buttonBackground, for: .normal)
        generateWeatherButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func cityLabelSetup () {
        cityLabel.text = ""
        cityLabel.textAlignment = .center
        cityLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        cityLabel.textColor = .componentAccent
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func temperatureLabelSetup() {
        temperatureLabel.text = ""
        temperatureLabel.textColor = .textColor
        temperatureLabel.textAlignment = .center
        temperatureLabel.font = UIFont.systemFont(ofSize: 40, weight: .semibold)
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func weatherTypeLabelSetup() {
        weatherTypeLabel.text = ""
        weatherTypeLabel.textColor = .textColor
        weatherTypeLabel.textAlignment = .center
        weatherTypeLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func stackViewSetup() {
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: SetupButton
    
    private func setupButton() {
        generateWeatherButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        viewModel.buttonTapped(latitudeText: latitudeTextField.text, longitudeText: longitudeTextField.text)
    }
    
    func fetched(with weatherData: WeatherData) {
        DispatchQueue.main.async {
            self.updateUI(with: weatherData)
        }
    }
    
    func error() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: "Incorrect Coordinates. Please try again!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func updateUI(with weatherData: WeatherData) {
        cityLabel.text = weatherData.city.name
        temperatureLabel.text = "\(weatherData.list.first?.main.temp ?? 0) °F"
        weatherTypeLabel.text = weatherData.list.first?.weather.first?.description
    }
    
}


