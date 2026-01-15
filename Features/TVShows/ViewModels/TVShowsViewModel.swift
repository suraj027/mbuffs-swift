//
//  TVShowsViewModel.swift
//  mbuffs
//
//  Created by AI Assistant on 14/01/26.
//

import Foundation
import Combine

// MARK: - TV Genre Model
struct TVGenre: Identifiable, Hashable {
    let id: Int
    let name: String
    let color: TVGenreColor
    
    enum TVGenreColor: String, CaseIterable {
        case blue, purple, orange, teal, gray, pink, mint, yellow, indigo, coral, green, brown, cyan, red
        
        var foregroundColor: String {
            switch self {
            case .blue: return "007AFF"
            case .purple: return "AF52DE"
            case .orange: return "FF9500"
            case .teal: return "5AC8FA"
            case .gray: return "8E8E93"
            case .pink: return "FF2D55"
            case .mint: return "00C7BE"
            case .yellow: return "FFCC00"
            case .indigo: return "5856D6"
            case .coral: return "FF6B6B"
            case .green: return "34C759"
            case .brown: return "A2845E"
            case .cyan: return "32ADE6"
            case .red: return "FF3B30"
            }
        }
    }
}

@MainActor
class TVShowsViewModel: ObservableObject {
    @Published var currentlyStreaming: [TVShow] = []
    @Published var airingToday: [TVShow] = []
    @Published var popularShows: [TVShow] = []
    @Published var comingSoon: [TVShow] = []
    @Published var networks: [StreamingNetwork] = []
    @Published var genres: [TVGenre] = []
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
        
        self.currentlyStreaming = []
        self.airingToday = []
        self.popularShows = []
        self.comingSoon = []
        
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
        
        // TV Genres
        self.genres = [
            TVGenre(id: 10759, name: "Action", color: .blue),
            TVGenre(id: 16, name: "Animation", color: .purple),
            TVGenre(id: 35, name: "Comedy", color: .orange),
            TVGenre(id: 80, name: "Crime", color: .teal),
            TVGenre(id: 99, name: "Documentary", color: .gray),
            TVGenre(id: 18, name: "Drama", color: .pink),
            TVGenre(id: 10751, name: "Family", color: .mint),
            TVGenre(id: 10762, name: "Kids", color: .yellow),
            TVGenre(id: 9648, name: "Mystery", color: .indigo),
            TVGenre(id: 10763, name: "News", color: .coral),
            TVGenre(id: 10764, name: "Reality", color: .pink),
            TVGenre(id: 10765, name: "Science Fiction", color: .purple),
            TVGenre(id: 10766, name: "Soap", color: .green),
            TVGenre(id: 10767, name: "Talk", color: .coral),
            TVGenre(id: 10768, name: "War", color: .cyan),
            TVGenre(id: 37, name: "Western", color: .brown)
        ]
        
        isLoading = false
    }
    
    // Keep for backward compatibility
    func fetchPopularShows() async {
        await fetchAllData()
    }
}
