//
//  TVShowService.swift
//  mbuffs
//
//  Created by AI Assistant on 20/01/26.
//

import Foundation

/// Service for fetching TV show data from the custom TMDB API
class TVShowService {
    static let shared = TVShowService()
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    // MARK: - TV Show Details
    
    /// Fetches detailed information for a specific TV show
    /// - Parameter id: TMDB TV Show ID
    /// - Returns: TVShowDetails object with full information including cast, crew, videos, etc.
    func getTVShowDetails(id: Int) async throws -> TVShowDetails {
        return try await apiClient.fetch(.tvShowDetails(id: id))
    }
    
    // MARK: - TV Show Lists
    
    /// Fetches TV shows available for streaming, rent, or buy in India
    /// - Parameter page: Page number for pagination
    /// - Returns: TVShowResponse containing list of streaming TV shows
    func getStreamingTVShows(page: Int = 1) async throws -> TVShowResponse {
        return try await apiClient.fetch(.streamingTVShows(page: page))
    }
    
    /// Fetches popular TV shows
    /// - Parameter page: Page number for pagination
    /// - Returns: TVShowResponse containing list of popular TV shows
    func getPopularTVShows(page: Int = 1) async throws -> TVShowResponse {
        return try await apiClient.fetch(.popularTVShows(page: page))
    }
    
    /// Fetches TV shows airing in the next 7 days
    /// - Parameter page: Page number for pagination
    /// - Returns: TVShowResponse containing list of on-the-air TV shows
    func getOnTheAirTVShows(page: Int = 1) async throws -> TVShowResponse {
        return try await apiClient.fetch(.onTheAirTVShows(page: page))
    }
    
    // MARK: - Watch Providers
    
    /// Fetches available streaming providers for TV shows
    /// - Parameter region: Country code (default: "IN" for India)
    /// - Returns: WatchProviderListResponse containing available providers
    func getTVWatchProviders(region: String = "IN") async throws -> WatchProviderListResponse {
        return try await apiClient.fetch(.tvWatchProviders(region: region))
    }
}
