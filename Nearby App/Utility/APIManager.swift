//
//  APIManager.swift
//  Nearby App
//
//  Created by K Praveen Kumar on 11/05/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
}

final class APIManager {
    
    static let shared = APIManager()
    private init() {}

    func fetchVenues(lat: Double, lon: Double, range: String, query: String?, perPage: Int, page: Int, completion: @escaping (Result<VenueModel, Error>) -> Void) {
        var components = URLComponents(string: Constants.baseURL)
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.clientID),
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)"),
            URLQueryItem(name: "range", value: range),
            URLQueryItem(name: "per_page", value: "\(perPage)"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        if let query = query {
            components?.queryItems?.append(URLQueryItem(name: "q", value: query))
        }

        guard let url = components?.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let decoder = JSONDecoder()
                let venueModel = try decoder.decode(VenueModel.self, from: data)
                completion(.success(venueModel))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
