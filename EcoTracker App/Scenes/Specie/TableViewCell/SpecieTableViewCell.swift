//
//  SpecieTableViewCell.swift
//  EcoTracker App
//
//  Created by Saba Gogrichiani on 01.12.23.
//

import UIKit
import SDWebImage

class SpecieTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    private let speciesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let attributionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let wikipediaButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Wikipedia", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()

    // MARK: - Properties
    private var wikipediaURL: String?

    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    
    private func setupUI() {
        contentView.addSubview(speciesImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(attributionLabel)
        contentView.addSubview(wikipediaButton)
        
        NSLayoutConstraint.activate([
            speciesImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            speciesImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            speciesImageView.widthAnchor.constraint(equalToConstant: 80),
            speciesImageView.heightAnchor.constraint(equalToConstant: 80),
            
            nameLabel.leadingAnchor.constraint(equalTo: speciesImageView.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            attributionLabel.leadingAnchor.constraint(equalTo: speciesImageView.trailingAnchor, constant: 16),
            attributionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            
            wikipediaButton.leadingAnchor.constraint(equalTo: speciesImageView.trailingAnchor, constant: 16),
            wikipediaButton.topAnchor.constraint(equalTo: attributionLabel.bottomAnchor, constant: 8),
        ])
        
        speciesImageView.layer.cornerRadius = 8
        speciesImageView.clipsToBounds = true
        
        wikipediaButton.addTarget(self, action: #selector(wikipediaButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Public Methods
    
    func configure(with specie: Specie) {
        nameLabel.text = specie.taxon.name
        
        if let defaultPhoto = specie.taxon.defaultPhoto, let imageUrl = URL(string: defaultPhoto.url) {
            speciesImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder"))
            
            let commaIndex = defaultPhoto.attribution.firstIndex(of: ",")!
            let trimmedAttribution = String(defaultPhoto.attribution.prefix(upTo: commaIndex))
            attributionLabel.text = "Uploaded by: \(trimmedAttribution)"
        } else {
            speciesImageView.image = UIImage(named: "placeholder")
            attributionLabel.text = "No Author Found"
        }
        
        if let wikipediaURL = specie.taxon.wikipediaURL {
            wikipediaButton.isHidden = false
            wikipediaButton.tag = 42
            self.wikipediaURL = wikipediaURL
        } else {
            wikipediaButton.isHidden = true
            self.wikipediaURL = nil
        }
    }
    
    // MARK: - Actions
    @objc private func wikipediaButtonTapped() {
        guard let wikipediaURL = wikipediaURL, let url = URL(string: wikipediaURL) else {
            return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
