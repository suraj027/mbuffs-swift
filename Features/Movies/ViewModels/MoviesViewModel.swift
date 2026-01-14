//
//  MoviesViewModel.swift
//  mbuffs
//
//  Created by AI Assistant on 14/01/26.
//

import Foundation
import Combine

// MARK: - Genre Model
struct Genre: Identifiable, Hashable {
    let id: Int
    let name: String
    let color: GenreColor
    
    enum GenreColor: String, CaseIterable {
        case blue, green, purple, orange, teal, gray, pink, mint, coral, brown, indigo, yellow, red, cyan
        
        var foregroundColor: String {
            switch self {
            case .blue: return "007AFF"
            case .green: return "34C759"
            case .purple: return "AF52DE"
            case .orange: return "FF9500"
            case .teal: return "5AC8FA"
            case .gray: return "8E8E93"
            case .pink: return "FF2D55"
            case .mint: return "00C7BE"
            case .coral: return "FF6B6B"
            case .brown: return "A2845E"
            case .indigo: return "5856D6"
            case .yellow: return "FFCC00"
            case .red: return "FF3B30"
            case .cyan: return "32ADE6"
            }
        }
    }
}

// MARK: - Network Model
struct StreamingNetwork: Identifiable, Hashable {
    let id: Int
    let name: String
    let logoPath: String?
    
    var logoURL: URL? {
        guard let path = logoPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w200\(path)")
    }
}

@MainActor
class MoviesViewModel: ObservableObject {
    @Published var theatricalReleases: [Movie] = []
    @Published var currentlyStreaming: [Movie] = []
    @Published var comingSoon: [Movie] = []
    @Published var explore: [Movie] = []
    @Published var networks: [StreamingNetwork] = []
    @Published var genres: [Genre] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol? = nil) {
        self.apiClient = apiClient ?? APIClient.shared
    }

    func fetchAllData() async {
        isLoading = true
        errorMessage = nil
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        // Theatrical Releases
        self.theatricalReleases = [
            Movie(id: 1, title: "The Housemaid", overview: "Trying to escape her past, Millie Calloway accepts a job as a live-in housemaid for tech billionaire Alexander Winchester and his wife Nina. But as Millie settles in, she begins to suspect that Nina is being controlled—and the Winchesters' secrets are more twisted than she could have imagined.", posterPath: "/i9LKqjFYOJG6wYmlxQYbT2Xoqvh.jpg", backdropPath: nil, voteAverage: 7.8, releaseDate: "2025-12-25"),
            Movie(id: 2, title: "Anaconda", overview: "A group of friends on a river vacation find their trip turning into a nightmare as they face multiple crises head-on in the Amazon jungle.", posterPath: "/kLlLFWEpSpPE8xb2AoQhTTSzQZf.jpg", backdropPath: nil, voteAverage: 6.5, releaseDate: "2025-08-15"),
            Movie(id: 3, title: "Mission: Impossible 8", overview: "Ethan Hunt and his team face their most dangerous mission yet as they race against time to prevent global catastrophe.", posterPath: "/7GsM4mtM0worHnL3aJLwv8xJPTe.jpg", backdropPath: nil, voteAverage: 8.2, releaseDate: "2025-05-23")
        ]
        
        // Currently Streaming
        self.currentlyStreaming = [
            Movie(id: 4, title: "Five Nights at Freddy's 2", overview: "The terror continues as a new security guard discovers the dark secrets behind Freddy Fazbear's Pizza.", posterPath: "/6TbMVe9eSLeWgY9gKElQ8uwYA7L.jpg", backdropPath: nil, voteAverage: 7.1, releaseDate: "2025-12-05"),
            Movie(id: 5, title: "Wake Up Dead Man", overview: "Detective Benoit Blanc takes on his most baffling case yet in this Knives Out mystery.", posterPath: "/pzFbYJEaWFToXN6LYjzaUoWUPFq.jpg", backdropPath: nil, voteAverage: 7.9, releaseDate: "2025-11-27"),
            Movie(id: 6, title: "Wicked", overview: "The untold story of the witches of Oz, exploring the unlikely friendship between Elphaba and Glinda.", posterPath: "/kMe6TshEFuPGqLr4tJe2u4TK2ja.jpg", backdropPath: nil, voteAverage: 8.4, releaseDate: "2024-11-22"),
            Movie(id: 7, title: "Gladiator II", overview: "The epic saga continues as a new hero rises in the arena of ancient Rome.", posterPath: "/2cxhvwyEwRlysAmRH4iodkvo0z5.jpg", backdropPath: nil, voteAverage: 7.6, releaseDate: "2024-11-15")
        ]
        
        // Coming Soon
        self.comingSoon = [
            Movie(id: 8, title: "28 Years Later", overview: "The infected have evolved. Survivors must face a new nightmare in this continuation of the iconic horror franchise.", posterPath: "/qzH4Sj6TfVWdTqKGM0HxL3mSNRE.jpg", backdropPath: nil, voteAverage: 0, releaseDate: "2026-06-20"),
            Movie(id: 9, title: "A Private Life", overview: "An intimate drama exploring the complexities of modern relationships and personal secrets.", posterPath: "/jKvotlPY5u3J9y0N6yCU6lQ5h0r.jpg", backdropPath: nil, voteAverage: 0, releaseDate: "2026-03-14"),
            Movie(id: 10, title: "Night Patrol", overview: "A supernatural thriller following a night patrol officer who encounters unexplainable horrors.", posterPath: "/1E5baAaEse26fej7uHcjOgEE2jd.jpg", backdropPath: nil, voteAverage: 0, releaseDate: "2026-10-31")
        ]
        
        // Explore
        self.explore = [
            Movie(id: 11, title: "The Shawshank Redemption", overview: "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.", posterPath: "/9cqNxx0GxF0bflZmeSMuL5tnGzR.jpg", backdropPath: nil, voteAverage: 9.3, releaseDate: "1994-09-23"),
            Movie(id: 12, title: "The Godfather", overview: "The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.", posterPath: "/3bhkrj58Vtu7enYsRolD1fZdja1.jpg", backdropPath: nil, voteAverage: 9.2, releaseDate: "1972-03-14"),
            Movie(id: 13, title: "The Godfather Part II", overview: "The early life and career of Vito Corleone in 1920s New York City is portrayed, while his son, Michael, expands and tightens his grip on the family crime syndicate.", posterPath: "/hek3koDUyRQk7FIhPXsa6mT2Zc3.jpg", backdropPath: nil, voteAverage: 9.0, releaseDate: "1974-12-20"),
            Movie(id: 14, title: "Pulp Fiction", overview: "The lives of two mob hitmen, a boxer, a gangster and his wife intertwine in four tales of violence and redemption.", posterPath: "/fIE3lAGcZDV1G6XM5KmuWnNsPp1.jpg", backdropPath: nil, voteAverage: 8.9, releaseDate: "1994-10-14")
        ]
        
        // Networks
        self.networks = [
            StreamingNetwork(id: 1, name: "Netflix", logoPath: "/pbpMk2JmcoNnQwx5JGpXngfoWtp.png"),
            StreamingNetwork(id: 2, name: "Amazon Prime Video", logoPath: "/emthp39XA2YScoYL1p0sdbAH2WA.png"),
            StreamingNetwork(id: 3, name: "Apple TV", logoPath: "/6uhKBfmtzFqOcLousHwZuzcrScK.png"),
            StreamingNetwork(id: 4, name: "Crunchyroll", logoPath: "/rK8DRbCuqL2JnZC3NKzHaOeyMYV.png"),
            StreamingNetwork(id: 5, name: "Disney+", logoPath: "/97yvRBw1GzXX6a95gRqq3Y4a6xQ.png"),
            StreamingNetwork(id: 6, name: "HBO Max", logoPath: "/aS2zvJWn9mwiCOeaaCkIh4wleZS.png"),
            StreamingNetwork(id: 7, name: "Hulu", logoPath: "/pqUTCleNUiTLAVlelGxUgWn1ELh.png"),
            StreamingNetwork(id: 8, name: "Paramount+", logoPath: "/xbhHHa1YgtpwhC8lb1NQ3ACVcLd.png")
        ]
        
        // Genres
        self.genres = [
            Genre(id: 28, name: "Action", color: .blue),
            Genre(id: 12, name: "Adventure", color: .green),
            Genre(id: 16, name: "Animation", color: .purple),
            Genre(id: 35, name: "Comedy", color: .orange),
            Genre(id: 80, name: "Crime", color: .teal),
            Genre(id: 99, name: "Documentary", color: .gray),
            Genre(id: 18, name: "Drama", color: .pink),
            Genre(id: 10751, name: "Family", color: .mint),
            Genre(id: 14, name: "Fantasy", color: .coral),
            Genre(id: 36, name: "History", color: .brown),
            Genre(id: 27, name: "Horror", color: .red),
            Genre(id: 10402, name: "Music", color: .indigo),
            Genre(id: 9648, name: "Mystery", color: .teal),
            Genre(id: 10749, name: "Romance", color: .coral),
            Genre(id: 878, name: "Science Fiction", color: .blue),
            Genre(id: 53, name: "Thriller", color: .orange),
            Genre(id: 10752, name: "War", color: .cyan),
            Genre(id: 37, name: "Western", color: .brown)
        ]
        
        isLoading = false
    }
    
    // Keep for backward compatibility
    var popularMovies: [Movie] {
        theatricalReleases + currentlyStreaming
    }
    
    func fetchPopularMovies() async {
        await fetchAllData()
    }
}
