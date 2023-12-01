//
//  SpecieViewController.swift
//  EcoTracker App
//
//  Created by Saba Gogrichiani on 29.11.23.
//

import UIKit

final class SpecieViewController: UIViewController {
    
    // MARK: - Properties
    private var specieViewModel = SpecieViewModel()
    private var species: [Specie] = []
    
    // MARK: - UI Elements
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: view.bounds, style: .grouped)
        table.register(SpecieTableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let searchController: UISearchController! = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.placeholder = "Enter city (e.g. Tbilisi)"
        controller.hidesNavigationBarDuringPresentation = false
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.showsCancelButton = false
        controller.searchBar.searchTextField.textColor = UIColor.white
        return controller
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Specie"
        view.backgroundColor = .black
        setDelegates()
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        setupTableView()
        setupSearchController()
        setupNavigationItems()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
    }
    
    private func setupSearchController() {
        definesPresentationContext = true
    }
    
    private func setupNavigationItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Search",
            style: .plain,
            target: self,
            action: #selector(searchButtonTapped)
        )
        navigationItem.titleView = searchController.searchBar
    }
    
    private func setDelegates() {
        specieViewModel.delegate = self
        searchController.searchBar.delegate = self
    }
    
    // MARK: - Methods
    @objc private func searchButtonTapped() {
        dismissSearchBar()
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            print("Search text not available or empty.")
            return
        }
        specieViewModel.fetchCityData(for: searchText)
    }

    private func dismissSearchBar() {
        searchController.searchBar.resignFirstResponder()
    }
}

// MARK: - Extensions

extension SpecieViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return species.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SpecieTableViewCell else {
            fatalError("Failed to dequeue SpecieTableViewCell")
        }
        
        let specie = species[indexPath.row]
        cell.configure(with: specie)
        
        return cell
    }
}

extension SpecieViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100.0
    }
}

extension SpecieViewController: SpecieViewModelDelegate {
    func speciesFetched(_ species: [Specie]) {
        self.species = species
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showError(_ error: Error) {
        print("error")
    }
}

extension SpecieViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            species = []
            tableView.reloadData()
        }
    }
}
