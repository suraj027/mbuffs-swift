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
        
        // TODO: Implement real API calls to TMDB or similar service
        // For now, initialize with empty arrays - replace with actual API integration
        
        self.theatricalReleases = []
        self.currentlyStreaming = []
        self.comingSoon = []
        self.explore = []
        
        // Networks (static data - these don't change often)
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
        
        // Genres (static data from TMDB)
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
