//
//  Movie.swift
//  mbuffs
//
//  Created by AI Assistant on 14/01/26.
//

import Foundation

// MARK: - Movie Model (for lists)
struct Movie: Identifiable, Decodable, Hashable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double
    let releaseDate: String?
    let genreIds: [Int]?
    let adult: Bool?
    let popularity: Double?
    let originalLanguage: String?
    let originalTitle: String?
    let video: Bool?
    let voteCount: Int?

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
    
    var releaseYear: String? {
        guard let date = releaseDate, date.count >= 4 else { return nil }
        return String(date.prefix(4))
    }
}

// MARK: - Movie Response (for list endpoints)
struct MovieResponse: Decodable {
    let page: Int?
    let results: [Movie]
    let totalPages: Int?
    let totalResults: Int?
}

// MARK: - Movie Details (for detail endpoint)
struct MovieDetails: Identifiable, Decodable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double
    let voteCount: Int?
    let releaseDate: String?
    let runtime: Int?
    let budget: Int?
    let revenue: Int?
    let status: String?
    let tagline: String?
    let homepage: String?
    let imdbId: String?
    let adult: Bool?
    let popularity: Double?
    let originalLanguage: String?
    let originalTitle: String?
    
    // Nested objects
    let genres: [APIGenre]?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let spokenLanguages: [SpokenLanguage]?
    let collection: MovieCollection?
    
    // Appended responses from custom API
    let cast: [CastMember]?
    let crew: [CrewMember]?
    let videos: VideoResponse?
    let images: ImageResponse?
    let similar: MovieResponse?
    let recommendations: MovieResponse?
    let watchProviders: WatchProviderResponse?
    let contentRatings: String?
    let rating: Double?
    let directorMovies: [Movie]?
    
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
    
    var formattedRuntime: String? {
        guard let runtime = runtime else { return nil }
        let hours = runtime / 60
        let minutes = runtime % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }
    
    var formattedBudget: String? {
        guard let budget = budget, budget > 0 else { return nil }
        return formatCurrency(budget)
    }
    
    var formattedRevenue: String? {
        guard let revenue = revenue, revenue > 0 else { return nil }
        return formatCurrency(revenue)
    }
    
    private func formatCurrency(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$\(value)"
    }
    
    var releaseYear: String? {
        guard let date = releaseDate, date.count >= 4 else { return nil }
        return String(date.prefix(4))
    }
    
    var director: CrewMember? {
        crew?.first { $0.job?.lowercased() == "director" }
    }
    
    var trailers: [Video]? {
        videos?.results?.filter { $0.type?.lowercased() == "trailer" && $0.site?.lowercased() == "youtube" }
    }
}

// MARK: - API Genre (from TMDB API response - different from UI Genre)
struct APIGenre: Identifiable, Decodable, Hashable {
    let id: Int
    let name: String
}

// MARK: - Production Company
struct ProductionCompany: Identifiable, Decodable {
    let id: Int
    let name: String
    let logoPath: String?
    let originCountry: String?
    
    var logoURL: URL? {
        guard let path = logoPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w200\(path)")
    }
}

// MARK: - Production Country
struct ProductionCountry: Decodable, Hashable {
    let iso31661: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case iso31661 = "iso_3166_1"
        case name
    }
}

// MARK: - Spoken Language
struct SpokenLanguage: Decodable, Hashable {
    let iso6391: String?
    let name: String?
    let englishName: String?
    
    enum CodingKeys: String, CodingKey {
        case iso6391 = "iso_639_1"
        case name
        case englishName
    }
}

// MARK: - Movie Collection
struct MovieCollection: Identifiable, Decodable {
    let id: Int
    let name: String
    let posterPath: String?
    let backdropPath: String?
    let parts: [Movie]?
    
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
}

// MARK: - Cast Member
struct CastMember: Identifiable, Decodable, Hashable {
    let id: Int
    let name: String
    let character: String?
    let profilePath: String?
    let order: Int?
    let knownForDepartment: String?
    
    var profileURL: URL? {
        guard let path = profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w185\(path)")
    }
}

// MARK: - Crew Member
struct CrewMember: Identifiable, Decodable, Hashable {
    let id: Int
    let name: String
    let job: String?
    let department: String?
    let profilePath: String?
    
    var profileURL: URL? {
        guard let path = profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w185\(path)")
    }
}

// MARK: - Video Response
struct VideoResponse: Decodable {
    let results: [Video]?
}

// MARK: - Video
struct Video: Identifiable, Decodable, Hashable {
    let id: String
    let name: String?
    let key: String?
    let site: String?
    let type: String?
    let official: Bool?
    let publishedAt: String?
    
    var youtubeURL: URL? {
        guard let key = key, site?.lowercased() == "youtube" else { return nil }
        return URL(string: "https://www.youtube.com/watch?v=\(key)")
    }
    
    var thumbnailURL: URL? {
        guard let key = key, site?.lowercased() == "youtube" else { return nil }
        return URL(string: "https://img.youtube.com/vi/\(key)/hqdefault.jpg")
    }
}

// MARK: - Image Response
struct ImageResponse: Decodable {
    let backdrops: [ImageInfo]?
    let posters: [ImageInfo]?
    let logos: [ImageInfo]?
}

// MARK: - Image Info
struct ImageInfo: Decodable, Hashable {
    let filePath: String?
    let width: Int?
    let height: Int?
    let aspectRatio: Double?
    let voteAverage: Double?
    let iso6391: String?
    
    enum CodingKeys: String, CodingKey {
        case filePath
        case width
        case height
        case aspectRatio
        case voteAverage
        case iso6391 = "iso_639_1"
    }
    
    var imageURL: URL? {
        guard let path = filePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/original\(path)")
    }
}

// MARK: - Watch Provider Response
struct WatchProviderResponse: Decodable {
    let results: [String: WatchProviderCountry]?
}

// MARK: - Watch Provider Country
struct WatchProviderCountry: Decodable {
    let link: String?
    let flatrate: [WatchProvider]?
    let rent: [WatchProvider]?
    let buy: [WatchProvider]?
}

// MARK: - Watch Provider
struct WatchProvider: Identifiable, Decodable, Hashable {
    let providerId: Int
    let providerName: String?
    let logoPath: String?
    let displayPriority: Int?
    
    var id: Int { providerId }
    
    var logoURL: URL? {
        guard let path = logoPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w92\(path)")
    }
}
