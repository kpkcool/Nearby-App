//
//  VenueViewModel.swift
//  Nearby App
//
//  Created by K Praveen Kumar on 11/05/24.
//

import Foundation

class VenueViewModel {
    var venues: [Venue] = []
    var filteredVenues: [Venue] = []
    var currentPage = 1
    var isFetchingData = false
    var range: Int = 5
}

//MARK: - API Call
extension VenueViewModel {
    func fetchData(lat: Double, lon: Double, range: Int, completion: @escaping (Result<[Venue], Error>) -> Void) {
        
        guard !isFetchingData else { return }
        isFetchingData = true
        
        APIManager.shared.fetchVenues(lat: lat, lon: lon, range: "\(range)mi", query: "", perPage: 10, page: currentPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let venueModel):
                
                if venueModel.meta.total == 0 {
                    self.venues.removeAll()
                }
                
                // Append new venues to the array
                for venue in venueModel.venues {
                    self.venues.append(venue)
                }
                
                DispatchQueue.main.async {
                    self.isFetchingData = false
                    completion(.success(self.venues))
                }
                
            case .failure(let error):
                print("Error fetching venues: \(error.localizedDescription)")
                self.isFetchingData = false
                completion(.failure(error))
            }
        }
    }
}
