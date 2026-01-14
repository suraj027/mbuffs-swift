//
//  Endpoint.swift
//  mbuffs
//
//  Created by AI Assistant on 14/01/26.
//

import Foundation

enum Endpoint {
    case popularMovies
    case popularTVShows
    case movieDetails(id: Int)
    case tvShowDetails(id: Int)
    case search(query: String)
    case trending

    func path() -> String {
        switch self {
        case .popularMovies:
            return "/movie/popular"
        case .popularTVShows:
            return "/tv/popular"
        case .movieDetails(let id):
            return "/movie/\(id)"
        case .tvShowDetails(let id):
            return "/tv/\(id)"
        case .search:
            return "/search/multi"
        case .trending:
            return "/trending/all/day"
        }
    }

    func queryItems(apiKey: String) -> [URLQueryItem] {
        var items = [URLQueryItem(name: "api_key", value: apiKey)]
        
        switch self {
        case .search(let query):
            items.append(URLQueryItem(name: "query", value: query))
        default:
            break
        }
        return items
    }

    func url(baseURL: String, apiKey: String) -> URL? {
        var components = URLComponents(string: baseURL + path())
        components?.queryItems = queryItems(apiKey: apiKey)
        return components?.url
    }
}
