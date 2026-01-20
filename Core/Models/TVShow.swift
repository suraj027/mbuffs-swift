//
//  TVShow.swift
//  mbuffs
//
//  Created by AI Assistant on 14/01/26.
//

import Foundation

// MARK: - TVShow Model (for lists)
struct TVShow: Identifiable, Decodable, Hashable {
    let id: Int
    let name: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double
    let firstAirDate: String?
    let genreIds: [Int]?
    let popularity: Double?
    let originalLanguage: String?
    let originalName: String?
    let voteCount: Int?
    let originCountry: [String]?

    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }

    var backdropURL: URL? {
        guard let path = backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/original\(path)")
    }
    
    var formattedRating: String {
        String(format: "%.1f", voteAverage)
    }
    
    var firstAirYear: String? {
        guard let date = firstAirDate, date.count >= 4 else { return nil }
        return String(date.prefix(4))
    }
}

// MARK: - TVShow Response (for list endpoints)
struct TVShowResponse: Decodable {
    let page: Int?
    let results: [TVShow]
    let totalPages: Int?
    let totalResults: Int?
}

// MARK: - TVShow Details (for detail endpoint)
struct TVShowDetails: Identifiable, Decodable {
    let id: Int
    let name: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double
    let voteCount: Int?
    let firstAirDate: String?
    let lastAirDate: String?
    let status: String?
    let tagline: String?
    let homepage: String?
    let type: String?
    let inProduction: Bool?
    let numberOfSeasons: Int?
    let numberOfEpisodes: Int?
    let episodeRunTime: [Int]?
    let popularity: Double?
    let originalLanguage: String?
    let originalName: String?
    let originCountry: [String]?
    
    // Nested objects
    let genres: [APIGenre]?
    let networks: [TVNetwork]?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let spokenLanguages: [SpokenLanguage]?
    let seasons: [TVSeason]?
    let createdBy: [TVCreator]?
    let lastEpisodeToAir: TVEpisode?
    let nextEpisodeToAir: TVEpisode?
    
    // Appended responses from custom API
    let cast: [CastMember]?
    let crew: [CrewMember]?
    let videos: VideoResponse?
    let images: ImageResponse?
    let similar: TVShowResponse?
    let recommendations: TVShowResponse?
    let watchProviders: WatchProviderResponse?
    let contentRatings: String?
    let rating: Double?
    let trailers: [Video]?
    let creatorShows: [TVShow]?
    let latestEpisode: TVEpisode?
    
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }

    var backdropURL: URL? {
        guard let path = backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/original\(path)")
    }
    
    var formattedRating: String {
        String(format: "%.1f", rating ?? voteAverage)
    }
    
    var firstAirYear: String? {
        guard let date = firstAirDate, date.count >= 4 else { return nil }
        return String(date.prefix(4))
    }
    
    var averageEpisodeRuntime: String? {
        guard let runtimes = episodeRunTime, !runtimes.isEmpty else { return nil }
        let avg = runtimes.reduce(0, +) / runtimes.count
        return "\(avg)m"
    }
    
    var creator: TVCreator? {
        createdBy?.first
    }
}

// MARK: - TV Network
struct TVNetwork: Identifiable, Decodable, Hashable {
    let id: Int
    let name: String
    let logoPath: String?
    let originCountry: String?
    
    var logoURL: URL? {
        guard let path = logoPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w200\(path)")
    }
}

// MARK: - TV Season
struct TVSeason: Identifiable, Decodable, Hashable {
    let id: Int
    let name: String
    let seasonNumber: Int
    let episodeCount: Int?
    let airDate: String?
    let overview: String?
    let posterPath: String?
    let voteAverage: Double?
    
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w300\(path)")
    }
}

// MARK: - TV Episode
struct TVEpisode: Identifiable, Decodable, Hashable {
    let id: Int
    let name: String
    let overview: String?
    let seasonNumber: Int?
    let episodeNumber: Int?
    let airDate: String?
    let stillPath: String?
    let voteAverage: Double?
    let voteCount: Int?
    let runtime: Int?
    let showId: Int?
    
    var stillURL: URL? {
        guard let path = stillPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
    
    var episodeString: String {
        guard let season = seasonNumber, let episode = episodeNumber else { return "" }
        return "S\(season)E\(episode)"
    }
}

// MARK: - TV Creator
struct TVCreator: Identifiable, Decodable, Hashable {
    let id: Int
    let name: String
    let creditId: String?
    let gender: Int?
    let profilePath: String?
    
    var profileURL: URL? {
        guard let path = profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w185\(path)")
    }
}
