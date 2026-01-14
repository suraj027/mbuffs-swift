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
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        // Currently Streaming (Featured/Large cards)
        self.currentlyStreaming = [
            TVShow(id: 1, name: "The Rookie", overview: "Starting over isn't easy, especially for small-town guy John Nolan who, after a life-altering incident, is pursuing his dream of being an LAPD officer.", posterPath: "/wbeq3AlGDHFxL2evLYwk6i6qhHw.jpg", backdropPath: nil, voteAverage: 8.5, firstAirDate: "2018-10-16"),
            TVShow(id: 2, name: "Chicago P.D.", overview: "A riveting police drama about the men and women of the Chicago Police Department's District 21 who put it all on the line to serve and protect their community.", posterPath: "/fHCl6UXMu0fpBfIeKS8sYNzkjY4.jpg", backdropPath: nil, voteAverage: 8.4, firstAirDate: "2014-01-08"),
            TVShow(id: 3, name: "NCIS", overview: "From murder and espionage to terrorism and stolen submarines, a team of special agents investigates any crime that has a shred of evidence connected to Navy and Marine Corps personnel.", posterPath: "/2exOHePjOTquUsbThPGhuEjYTyA.jpg", backdropPath: nil, voteAverage: 7.6, firstAirDate: "2003-09-23")
        ]
        
        // Airing Today
        self.airingToday = [
            TVShow(id: 4, name: "The Loud House", overview: "Lincoln Loud is an 11-year-old boy who lives with his ten sisters. With the help of his best friend Clyde, Lincoln finds new ways to survive in such a large family.", posterPath: "/mIVJ9hFWpWbsS3rS1KLvHvbIIQj.jpg", backdropPath: nil, voteAverage: 7.8, firstAirDate: "2016-05-02"),
            TVShow(id: 5, name: "Father Brown", overview: "Pastor Brown solves mysteries in his English village, using his knowledge of human nature and his unwavering faith.", posterPath: "/jJ9ScZIZrF0vHM4VHYxgf5EVLKA.jpg", backdropPath: nil, voteAverage: 7.6, firstAirDate: "2013-01-14"),
            TVShow(id: 6, name: "RuPaul's Drag Race", overview: "RuPaul searches for America's next drag superstar. Contestants must compete in challenges to determine who is the best.", posterPath: "/6LThfVcGWSLswQaQh5vH5ycxwKg.jpg", backdropPath: nil, voteAverage: 7.5, firstAirDate: "2009-02-02"),
            TVShow(id: 7, name: "The Simpsons", overview: "Set in Springfield, the average American town, the show focuses on the antics and everyday adventures of the Simpson family.", posterPath: "/vHqeLzYl3dEAutojCO26g0LIkom.jpg", backdropPath: nil, voteAverage: 8.0, firstAirDate: "1989-12-17")
        ]
        
        // Popular Shows
        self.popularShows = [
            TVShow(id: 8, name: "Stranger Things", overview: "When a young boy vanishes, a small town uncovers a mystery involving secret experiments, terrifying supernatural forces and one strange little girl.", posterPath: "/49WJfeN0moxb9IPfGn8AIqMGskD.jpg", backdropPath: nil, voteAverage: 8.6, firstAirDate: "2016-07-15"),
            TVShow(id: 9, name: "Watch What Happens Live", overview: "Andy Cohen hosts a live talk show featuring celebrity guests and viewer interaction.", posterPath: "/p2lfoLYYYVXuuuA4KHKmr5BfxU4.jpg", backdropPath: nil, voteAverage: 5.4, firstAirDate: "2009-07-16"),
            TVShow(id: 10, name: "The Return of Superman", overview: "Celebrity fathers are left to care for their children alone for 48 hours without the help of their wives.", posterPath: "/xIfvqDmwMpkpJBOoPFwQP9gjsL6.jpg", backdropPath: nil, voteAverage: 8.2, firstAirDate: "2013-11-03"),
            TVShow(id: 11, name: "Breaking Bad", overview: "When Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a prognosis of only two years left to live.", posterPath: "/ggFHVNu6YYI5L9pCfOacjizRGt.jpg", backdropPath: nil, voteAverage: 9.5, firstAirDate: "2008-01-20")
        ]
        
        // Coming Soon
        self.comingSoon = [
            TVShow(id: 12, name: "Maxxed Out", overview: "Money talks, so should we. A new series exploring financial extremes.", posterPath: "/1E5baAaEse26fej7uHcjOgEE2jd.jpg", backdropPath: nil, voteAverage: 0, firstAirDate: "2026-01-10"),
            TVShow(id: 13, name: "Fear Factor: The Next Chapter", overview: "Johnny Knoxville hosts a new generation of the legendary extreme competition show.", posterPath: "/qzH4Sj6TfVWdTqKGM0HxL3mSNRE.jpg", backdropPath: nil, voteAverage: 0, firstAirDate: "2026-03-15"),
            TVShow(id: 14, name: "The Last of Us Season 3", overview: "Joel and Ellie's journey continues in the post-apocalyptic world.", posterPath: "/uKvVjHNqB5VmOrdxqAt2F7J78ED.jpg", backdropPath: nil, voteAverage: 0, firstAirDate: "2026-06-01")
        ]
        
        // Networks (shared with Movies)
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
