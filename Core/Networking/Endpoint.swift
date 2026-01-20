//
//  Endpoint.swift
//  mbuffs
//
//  Created by AI Assistant on 14/01/26.
//

import Foundation

enum Endpoint {
    // MARK: - Movies
    case movieDetails(id: Int)
    case theatricalMovies(page: Int = 1)
    case streamingMovies(page: Int = 1)
    case upcomingMovies(page: Int = 1)
    case exploreMovies(sortBy: String? = nil, genres: String? = nil, year: Int? = nil, page: Int = 1)
    case comedyMovies(page: Int = 1)
    case horrorMovies(page: Int = 1)
    case movieChanges(startDate: String? = nil, endDate: String? = nil, page: Int = 1)
    
    // MARK: - TV Shows
    case tvShowDetails(id: Int)
    case streamingTVShows(page: Int = 1)
    case popularTVShows(page: Int = 1)
    case onTheAirTVShows(page: Int = 1)
    
    // MARK: - Watch Providers
    case movieWatchProviders(region: String = "IN")
    case tvWatchProviders(region: String = "IN")
    
    // MARK: - Search (placeholder for future)
    case search(query: String)
    
    func path() -> String {
        switch self {
        // Movies
        case .movieDetails(let id):
            return "/api/movie/\(id)"
        case .theatricalMovies:
            return "/api/movie/theatrical"
        case .streamingMovies:
            return "/api/movie/streaming"
        case .upcomingMovies:
            return "/api/movie/upcoming"
        case .exploreMovies:
            return "/api/movie/explore"
        case .comedyMovies:
            return "/api/movie/comedy"
        case .horrorMovies:
            return "/api/movie/horror"
        case .movieChanges:
            return "/api/movie/changes"
            
        // TV Shows
        case .tvShowDetails(let id):
            return "/api/tv/\(id)"
        case .streamingTVShows:
            return "/api/tv/streaming"
        case .popularTVShows:
            return "/api/tv/popular"
        case .onTheAirTVShows:
            return "/api/tv/on-the-air"
            
        // Watch Providers
        case .movieWatchProviders:
            return "/api/watch-providers/movie"
        case .tvWatchProviders:
            return "/api/watch-providers/tv"
            
        // Search
        case .search:
            return "/api/search"
        }
    }

    func queryItems() -> [URLQueryItem]? {
        var items: [URLQueryItem] = []
        
        switch self {
        case .theatricalMovies(let page),
             .streamingMovies(let page),
             .upcomingMovies(let page),
             .comedyMovies(let page),
             .horrorMovies(let page),
             .streamingTVShows(let page),
             .popularTVShows(let page),
             .onTheAirTVShows(let page):
            if page > 1 {
                items.append(URLQueryItem(name: "page", value: String(page)))
            }
            
        case .exploreMovies(let sortBy, let genres, let year, let page):
            if let sortBy = sortBy {
                items.append(URLQueryItem(name: "sort_by", value: sortBy))
            }
            if let genres = genres {
                items.append(URLQueryItem(name: "with_genres", value: genres))
            }
            if let year = year {
                items.append(URLQueryItem(name: "primary_release_year", value: String(year)))
            }
            if page > 1 {
                items.append(URLQueryItem(name: "page", value: String(page)))
            }
            
        case .movieChanges(let startDate, let endDate, let page):
            if let startDate = startDate {
                items.append(URLQueryItem(name: "start_date", value: startDate))
            }
            if let endDate = endDate {
                items.append(URLQueryItem(name: "end_date", value: endDate))
            }
            if page > 1 {
                items.append(URLQueryItem(name: "page", value: String(page)))
            }
            
        case .movieWatchProviders(let region),
             .tvWatchProviders(let region):
            items.append(URLQueryItem(name: "watch_region", value: region))
            
        case .search(let query):
            items.append(URLQueryItem(name: "query", value: query))
            
        case .movieDetails, .tvShowDetails:
            return nil
        }
        
        return items.isEmpty ? nil : items
    }

    func url(baseURL: String) -> URL? {
        var components = URLComponents(string: baseURL + path())
        components?.queryItems = queryItems()
        return components?.url
    }
}
