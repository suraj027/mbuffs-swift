//
//  MovieService.swift
//  mbuffs
//
//  Created by AI Assistant on 20/01/26.
//

import Foundation

/// Service for fetching movie data from the custom TMDB API
class MovieService {
    static let shared = MovieService()
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    // MARK: - Movie Details
    
    /// Fetches detailed information for a specific movie
    /// - Parameter id: TMDB Movie ID
    /// - Returns: MovieDetails object with full information including cast, crew, videos, etc.
    func getMovieDetails(id: Int) async throws -> MovieDetails {
        return try await apiClient.fetch(.movieDetails(id: id))
    }
    
    // MARK: - Movie Lists
    
    /// Fetches movies currently playing in theaters in India
    /// - Parameter page: Page number for pagination
    /// - Returns: MovieResponse containing list of theatrical movies
    func getTheatricalMovies(page: Int = 1) async throws -> MovieResponse {
        return try await apiClient.fetch(.theatricalMovies(page: page))
    }
    
    /// Fetches movies available for streaming, rent, or buy in India
    /// - Parameter page: Page number for pagination
    /// - Returns: MovieResponse containing list of streaming movies
    func getStreamingMovies(page: Int = 1) async throws -> MovieResponse {
        return try await apiClient.fetch(.streamingMovies(page: page))
    }
    
    /// Fetches upcoming movies scheduled for release
    /// - Parameter page: Page number for pagination
    /// - Returns: MovieResponse containing list of upcoming movies
    func getUpcomingMovies(page: Int = 1) async throws -> MovieResponse {
        return try await apiClient.fetch(.upcomingMovies(page: page))
    }
    
    /// Fetches comedy movies
    /// - Parameter page: Page number for pagination
    /// - Returns: MovieResponse containing list of comedy movies
    func getComedyMovies(page: Int = 1) async throws -> MovieResponse {
        return try await apiClient.fetch(.comedyMovies(page: page))
    }
    
    /// Fetches horror movies
    /// - Parameter page: Page number for pagination
    /// - Returns: MovieResponse containing list of horror movies
    func getHorrorMovies(page: Int = 1) async throws -> MovieResponse {
        return try await apiClient.fetch(.horrorMovies(page: page))
    }
    
    // MARK: - Explore Movies
    
    /// Discover movies with various filters
    /// - Parameters:
    ///   - sortBy: Sort option (e.g., "popularity.desc", "release_date.desc")
    ///   - genres: Comma-separated genre IDs (e.g., "28,12" for Action, Adventure)
    ///   - year: Filter by primary release year
    ///   - page: Page number for pagination
    /// - Returns: MovieResponse containing filtered movie list
    func exploreMovies(
        sortBy: String? = nil,
        genres: String? = nil,
        year: Int? = nil,
        page: Int = 1
    ) async throws -> MovieResponse {
        return try await apiClient.fetch(.exploreMovies(sortBy: sortBy, genres: genres, year: year, page: page))
    }
    
    // MARK: - Movie Changes
    
    /// Fetches list of movie IDs that have been updated
    /// - Parameters:
    ///   - startDate: Filter from date (YYYY-MM-DD format)
    ///   - endDate: Filter to date (YYYY-MM-DD format)
    ///   - page: Page number for pagination
    /// - Returns: MovieResponse containing list of changed movies
    func getMovieChanges(
        startDate: String? = nil,
        endDate: String? = nil,
        page: Int = 1
    ) async throws -> MovieResponse {
        return try await apiClient.fetch(.movieChanges(startDate: startDate, endDate: endDate, page: page))
    }
    
    // MARK: - Watch Providers
    
    /// Fetches available streaming providers for movies
    /// - Parameter region: Country code (default: "IN" for India)
    /// - Returns: WatchProviderListResponse containing available providers
    func getMovieWatchProviders(region: String = "IN") async throws -> WatchProviderListResponse {
        return try await apiClient.fetch(.movieWatchProviders(region: region))
    }
}

// MARK: - Watch Provider List Response

struct WatchProviderListResponse: Decodable {
    let results: [WatchProviderItem]?
}

struct WatchProviderItem: Identifiable, Decodable {
    let providerId: Int
    let providerName: String?
    let logoPath: String?
    let displayPriority: Int?
    let displayPriorities: [String: Int]?
    
    var id: Int { providerId }
    
    var logoURL: URL? {
        guard let path = logoPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w92\(path)")
    }
}
