//
//  VenueModel.swift
//  Nearby App
//
//  Created by K Praveen Kumar on 11/05/24.
//

import Foundation

// MARK: - VenueModel
struct VenueModel: Codable {
    let venues: [Venue]
    let meta: Meta
}

// MARK: - Meta
struct Meta: Codable {
    let total, took, page, perPage: Int
    let geolocation: Geolocation

    enum CodingKeys: String, CodingKey {
        case total, took, page
        case perPage = "per_page"
        case geolocation
    }
}

// MARK: - Geolocation
struct Geolocation: Codable {
    let lat, lon: Double
    let city, state, country, postalCode: String
    let displayName: String
    let range: String

    enum CodingKeys: String, CodingKey {
        case lat, lon, city, state, country
        case postalCode = "postal_code"
        case displayName = "display_name"
        case range
    }
}

// MARK: - Venue
struct Venue: Codable {
    let nameV2, postalCode, name: String?
    let timezone: String?
    let url: String?
    let score: Int
    let location: Location
    let address: String?
    let country: String?
    let hasUpcomingEvents: Bool
    let numUpcomingEvents: Int
    let city: String?
    let slug: String?
    let extendedAddress: String?
    let id, popularity: Int
    let metroCode, capacity: Int
    let displayLocation: String?
    
    // Computed Property
    var completeAddress: String? {
        var components: [String] = []
        if let address = address {
            components.append(address)
        }
        if let extendedAddress = extendedAddress {
            components.append(extendedAddress)
        }
        if let postalCode = postalCode {
            components.append(postalCode)
        }
        if let city = city {
            components.append(city)
        }
        return components.isEmpty ? nil : components.joined(separator: ", ")
    }

    enum CodingKeys: String, CodingKey {
        case nameV2 = "name_v2"
        case postalCode = "postal_code"
        case name, timezone, url, score, location, address, country
        case hasUpcomingEvents = "has_upcoming_events"
        case numUpcomingEvents = "num_upcoming_events"
        case city, slug
        case extendedAddress = "extended_address"
        case id, popularity
        case metroCode = "metro_code"
        case capacity
        case displayLocation = "display_location"
    }
}

// MARK: - Location
struct Location: Codable {
    let lat, lon: Double
}
