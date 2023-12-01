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
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    private var searchController: UISearchController! = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.placeholder = "Enter city (e.g. Tbilisi)"
        controller.hidesNavigationBarDuringPresentation = false
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.showsCancelButton = false
        return controller
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Specie"
        specieViewModel.delegate = self
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

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SpecieViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Adjust this value based on your desired cell height
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        species.count
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
