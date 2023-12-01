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

    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Population"
    }
    
    // MARK: - Private Methods
}
