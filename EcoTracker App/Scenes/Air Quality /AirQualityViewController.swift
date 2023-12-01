//
//  AirQualityViewController.swift
//  EcoTracker App
//
//  Created by Saba Gogrichiani on 29.11.23.
//

import UIKit

final class AirQualityViewController: UIViewController {
    
    // MARK: - UI Components
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cloud1")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.heightAnchor.constraint(equalToConstant: 210).isActive = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "GillSans-Bold", size: 24)
        label.numberOfLines = 0
        label.textColor = UIColor.textColor
        return label
    }()
    
    private var indexLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
        label.numberOfLines = 0
        label.textColor = UIColor.componentAccent
        return label
    }()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        label.numberOfLines = 0
        label.textColor = UIColor.buttonBackground
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        label.textColor = .white
        return label
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.placeholder = "Enter city (e.g. Tbilisi)"
        controller.hidesNavigationBarDuringPresentation = false
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.showsCancelButton = false
        controller.searchBar.searchTextField.textColor = UIColor.white
        
        return controller
    }()
    
    private let viewModel = AirQualityViewModel()
    private var airQuality = [AirQualityModel]()
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setDelegates()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = UIColor.backgroundColor
        setupStackView()
        setupStackViewConstraints()
        setupSearchController()
        setupNavigationItems()
        setDefaultLabels()
    }
    
    private func setDelegates() {
        viewModel.delegate = self
        searchController.searchBar.delegate = self
    }
    
    private func setupStackView() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(indexLabel)
        stackView.addArrangedSubview(conditionLabel)
        stackView.addArrangedSubview(descriptionLabel)
    }
    
    private func setupStackViewConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func setupSearchController() {
        definesPresentationContext = true
    }
    
    private func setupNavigationItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Search",
            style: .plain,
            target: self,
            action: #selector(searchButtonPressed)
        )
        navigationItem.titleView = searchController.searchBar
    }
    
    @objc private func searchButtonPressed() {
        dismissSearchBar()
        setDefaultLabels()
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            return
        }
        viewModel.fetchAirQuality(with: searchText)
    }
    
    private func setDefaultLabels() {
        titleLabel.text = "AIR QUALITY INDEX"
        indexLabel.text = ""
        conditionLabel.text = ""
        descriptionLabel.text = "The Air Quality Index (AQI) is like a weather report for the air we breathe. It measures how clean or polluted the air is and assigns a number from 0 to 500. The lower the number, the better the air quality – green is good! When the AQI is 0-50, it's all clear, and you can breathe easy. But as it climbs, especially into 151-200, it's a sign that the air quality is taking a turn for the worse. At 201-300, it's time to tread carefully – that's when the air might not be so friendly. And if it skyrockets to 301-500, it's a red alert – that air is as serious as it gets, and it's best to stay indoors until it clears up. Keep an eye on the AQI, and you'll know when it's a good day for a picnic or a cozy night in!"
    }
    
    private func dismissSearchBar() {
        searchController.searchBar.resignFirstResponder()
    }
    
    func configure(with city: AirQualityModel) {
        DispatchQueue.main.async {
            self.indexLabel.text = "\(city.airQuality)"
        }
    }
}

// MARK: - AirQualityViewModelDelegate
extension AirQualityViewController: AirQualityViewModelDelegate {
    func airQualityFetched(_ airQuality: [AirQualityModel]) {
        self.airQuality = airQuality
        if let firstCity = airQuality.first {
            self.configure(with: firstCity)
            updateConditionLabel(for: firstCity.airQuality)
            updateDescriptionLabel(for: firstCity.airQuality)
        }
    }
    
    func showError(_ error: Error) {
        print(error.localizedDescription)
    }
    
    private func updateConditionLabel(for airQualityIndex: Int) {
        let condition = viewModel.getConditionLabel(for: airQualityIndex)
        conditionLabel.text = condition
    }
    
    private func updateDescriptionLabel(for airQualityIndex: Int) {
        let description = viewModel.getDescription(for: airQualityIndex)
        descriptionLabel.text = description
    }
}

// MARK: - UISearchBarDelegate
extension AirQualityViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            setDefaultLabels()
        }
    }
}
