//
//  ViewController.swift
//  Nearby App
//
//  Created by K Praveen Kumar on 11/05/24.
//

import UIKit

class VenueListViewController: UIViewController {
    
    //MARK: - Properties
    private let tableView = UITableView()
    private let slider = UISlider()
    private let searchController = UISearchController(searchResultsController: nil)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    static let searchPlaceHolder = "Search Venues"
    private let venueViewModel = VenueViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }
    
    private func setupUI() {
        /// Table view
        tableView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 100)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: String(describing: VenueTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: VenueTableViewCell.self))
        view.addSubview(tableView)
        
        /// Search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = VenueListViewController.searchPlaceHolder
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        /// Slider
        slider.frame = CGRect(x: 20, y: view.bounds.height - 80, width: view.bounds.width - 40, height: 20)
        slider.minimumValue = 0
        slider.maximumValue = 50
        slider.value = Float(venueViewModel.range)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        view.addSubview(slider)
        
        /// Activity indicator
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }
}

//MARK: - Private Methods
private extension VenueListViewController {
    func fetchData() {
        activityIndicator.startAnimating()
        venueViewModel.fetchData(lat: Constants.latitue,
                                 lon: Constants.longitude,
                                 range: venueViewModel.range) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            case .failure(let error):
                print("Error fetching venues: \(error.localizedDescription)")
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    @objc func sliderValueChanged() {
        venueViewModel.range = Int(slider.value)
        self.fetchData()
    }
}

//MARK: - UITableView DataSource
extension VenueListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering() ? venueViewModel.filteredVenues.count : venueViewModel.venues.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: VenueTableViewCell.self), for: indexPath) as? VenueTableViewCell else { return UITableViewCell() }
        let venue = isFiltering() ? venueViewModel.filteredVenues[indexPath.row] : venueViewModel.venues[indexPath.row]
        cell.configure(heading: venue.name ?? "", subheading: venue.completeAddress ?? "")
        return cell
    }
}

//MARK: - UITableView Delegate
extension VenueListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height, !venueViewModel.isFetchingData {
            venueViewModel.currentPage += 1
            fetchData() /// Load next page
        }
    }
}

//MARK: - UISearch Results
extension VenueListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterVenues(for: searchController.searchBar.text ?? "")
    }

    private func filterVenues(for searchText: String) {
        venueViewModel.filteredVenues = venueViewModel.venues.filter { venue in
            let nameMatch = venue.name?.lowercased().contains(searchText.lowercased()) ?? false
            let addressMatch = venue.completeAddress?.lowercased().contains(searchText.lowercased()) ?? false
            return nameMatch || addressMatch
        }
        tableView.reloadData()
    }

    private func isFiltering() -> Bool {
        return searchController.isActive && !isSearchBarEmpty()
    }

    private func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
}
