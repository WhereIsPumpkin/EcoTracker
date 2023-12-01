//
//  PopulationViewController.swift
//  EcoTracker App
//
//  Created by Saba Gogrichiani on 29.11.23.
//

import UIKit

final class PopulationViewController: UIViewController {
    // MARK: - Properties
    
    private let countryField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Country"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        return textField
    }()
    
    private let fetchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Fetch Population", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        button.backgroundColor = .buttonBackground
        return button
    }()
    
    private let todayPopulationLabel: UILabel = {
        let label = UILabel()
        label.text = "Today's Population: "
        label.textColor = UIColor.white
        return label
    }()
    
    private let tomorrowPopulationLabel: UILabel = {
        let label = UILabel()
        label.text = "Tomorrow's Population: "
        label.textColor = UIColor.white
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fetchButton])
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [todayPopulationLabel, tomorrowPopulationLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [countryField, buttonStackView, labelStackView])
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 200, left: 40, bottom: 0, right: 40)
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let people = [TotalPopulation.Population]()
    private var viewModel = PopulationViewModel()
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarTitle()
        setupBackground()
        addSubviewsToView()
        setupViewModelDelegate()
    }
    
    // MARK: - Private Methods
    
    private func setupNavigationBarTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "Air Quality"
        titleLabel.textColor = .white
        navigationItem.titleView = titleLabel
    }
    
    private func setupBackground() {
        view.backgroundColor = .backgroundColor
    }
    
    private func addSubviewsToView() {
        addMainSubviews()
        setupConstraints()
    }
    
    private func addMainSubviews() {
        view.addSubview(mainStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor),
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor)
        ])
    }
    
    private func setupViewModelDelegate() {
        viewModel.delegate = self
        
        fetchButton.addTarget(self, action: #selector(fetchPopulationButtonTapped), for: .touchUpInside)
        
    }
    @objc private func fetchPopulationButtonTapped() {
        guard let country = countryField.text, !country.isEmpty else {
            print("No country entered")
            return
        }
        
        viewModel.fetchPopulationData(for: [country])
    }
}
// MARK: - PopulationViewModelDelegate

extension PopulationViewController: PopulationViewModelDelegate {
    func didFetchTotalPopulation(_ totalPopulation: [String : [TotalPopulation.Population]]) {
        for (country, populationData) in totalPopulation {
            print("Country: \(country)")
            for population in populationData {
                print("Date: \(population.date), Population: \(population.population)")
            }
            let todayPopulation = populationData.first?.population ?? 0
            let tomorrowPopulation = populationData.last?.population ?? 0
            todayPopulationLabel.text = "Today's Population: \(todayPopulation)"
            tomorrowPopulationLabel.text = "Tomorrow's Population: \(tomorrowPopulation)"
        }
    }
    
    func didFailWithError(_ error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "Invalid country name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
