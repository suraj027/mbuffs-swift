//
//  MoviesHomeView.swift
//  mbuffs
//
//  Created by AI Assistant on 14/01/26.
//

import SwiftUI

struct MoviesHomeView: View {
    @StateObject private var viewModel = MoviesViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 28) {
                    if viewModel.isLoading {
                        // Skeleton Loading State
                        SkeletonLargeCardsSection()
                        SkeletonMediumCardsSection()
                        SkeletonMediumCardsSection()
                        SkeletonMediumCardsSection()
                        SkeletonNetworksSection()
                        SkeletonGenresSection()
                    } else {
                        // Theatrical Releases Section
                        theatricalReleasesSection
                        
                        // Currently Streaming Section
                        currentlyStreamingSection
                        
                        // Coming Soon Section
                        comingSoonSection
                        
                        // Explore Section
                        exploreSection
                        
                        // Networks Section
                        networksSection
                        
                        // Genres Section
                        genresSection
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 100) // Space for TabBar
            }
            .background(Color(uiColor: .systemBackground))
            .navigationTitle("Movies")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 12) {
                        Button(action: { /* Shuffle action */ }) {
                            Image(systemName: "shuffle")
                                .font(.body.weight(.medium))
                                .foregroundColor(.primary)
                                .frame(width: 40, height: 40)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                        
                        Button(action: { /* More options */ }) {
                            Image(systemName: "ellipsis")
                                .font(.body.weight(.medium))
                                .foregroundColor(.primary)
                                .frame(width: 40, height: 40)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                    }
                }
            }
            .task {
                await viewModel.fetchAllData()
            }
        }
    }
    
    // MARK: - Theatrical Releases
    private var theatricalReleasesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(
                title: "Theatrical Releases",
                subtitle: "Discover the latest theatrical releases"
            )
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    if viewModel.theatricalReleases.isEmpty {
                        ForEach(0..<3, id: \.self) { _ in
                            SkeletonLargePosterCard()
                        }
                    } else {
                        ForEach(viewModel.theatricalReleases) { movie in
                            NavigationLink(destination: MovieDetailsView(movie: movie)) {
                                LargePosterCard(movie: movie)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Currently Streaming
    private var currentlyStreamingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(
                title: "Currently Streaming",
                subtitle: "Discover the latest home releases"
            )
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    if viewModel.currentlyStreaming.isEmpty {
                        ForEach(0..<5, id: \.self) { _ in
                            SkeletonMediumPosterCard()
                        }
                    } else {
                        ForEach(viewModel.currentlyStreaming) { movie in
                            NavigationLink(destination: MovieDetailsView(movie: movie)) {
                                MediumPosterCard(movie: movie)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Coming Soon
    private var comingSoonSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(
                title: "Coming Soon",
                subtitle: "Anticipated movies"
            )
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    if viewModel.comingSoon.isEmpty {
                        ForEach(0..<5, id: \.self) { _ in
                            SkeletonMediumPosterCard()
                        }
                    } else {
                        ForEach(viewModel.comingSoon) { movie in
                            NavigationLink(destination: MovieDetailsView(movie: movie)) {
                                MediumPosterCard(movie: movie)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Explore
    private var exploreSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(
                title: "Explore",
                subtitle: "Your next watch"
            )
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    if viewModel.explore.isEmpty {
                        ForEach(0..<5, id: \.self) { _ in
                            SkeletonMediumPosterCard()
                        }
                    } else {
                        ForEach(viewModel.explore) { movie in
                            NavigationLink(destination: MovieDetailsView(movie: movie)) {
                                MediumPosterCard(movie: movie)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Networks
    private var networksSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(
                title: "Networks",
                subtitle: "Available watch providers"
            )
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.networks) { network in
                        NetworkCard(network: network)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Genres
    private var genresSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(
                title: "Genres",
                subtitle: "Movies by genre",
                showChevron: false
            )
            
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ],
                spacing: 12
            ) {
                ForEach(viewModel.genres) { genre in
                    Button(action: { /* Navigate to genre */ }) {
                        GenreButton(genre: genre)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Large Poster Card (Featured/Theatrical)
struct LargePosterCard: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: movie.posterURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(2/3, contentMode: .fill)
                case .failure(_):
                    posterPlaceholder
                case .empty:
                    posterPlaceholder
                        .overlay(ProgressView().tint(.white))
                @unknown default:
                    posterPlaceholder
                }
            }
            .frame(width: 280, height: 420)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(movie.overview)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .frame(width: 280, alignment: .leading)
        }
    }
    
    private var posterPlaceholder: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.gray.opacity(0.3))
            .overlay(
                Image(systemName: "film")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            )
    }
}

// MARK: - Medium Poster Card
struct MediumPosterCard: View {
    let movie: Movie
    let showTitle: Bool
    
    init(movie: Movie, showTitle: Bool = false) {
        self.movie = movie
        self.showTitle = showTitle
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            AsyncImage(url: movie.posterURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(2/3, contentMode: .fill)
                case .failure(_):
                    posterPlaceholder
                case .empty:
                    posterPlaceholder
                        .overlay(ProgressView().tint(.white))
                @unknown default:
                    posterPlaceholder
                }
            }
            .frame(width: 140, height: 210)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            
            if showTitle {
                Text(movie.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .frame(width: 140, alignment: .leading)
            }
        }
    }
    
    private var posterPlaceholder: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.3))
            .overlay(
                Image(systemName: "film")
                    .font(.title2)
                    .foregroundColor(.gray)
            )
    }
}

// MARK: - Network Card
struct NetworkCard: View {
    let network: StreamingNetwork
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(uiColor: .secondarySystemBackground))
                    .frame(width: 70, height: 70)
                
                AsyncImage(url: network.logoURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                    case .failure(_):
                        networkPlaceholder
                    case .empty:
                        networkPlaceholder
                    @unknown default:
                        networkPlaceholder
                    }
                }
            }
            
            Text(network.name)
                .font(.caption2)
                .foregroundColor(.secondary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 70)
        }
    }
    
    private var networkPlaceholder: some View {
        Image(systemName: "tv")
            .font(.title2)
            .foregroundColor(.gray)
    }
}

// MARK: - Genre Button
struct GenreButton: View {
    let genre: Genre
    
    var body: some View {
        Text(genre.name)
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(genreColor)
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(genreColor.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 14))
    }
    
    private var genreColor: Color {
        switch genre.color {
        case .blue: return .blue
        case .green: return .green
        case .purple: return .purple
        case .orange: return .orange
        case .teal: return .teal
        case .gray: return .gray
        case .pink: return .pink
        case .mint: return .mint
        case .coral: return Color(red: 1.0, green: 0.42, blue: 0.42)
        case .brown: return .brown
        case .indigo: return .indigo
        case .yellow: return .yellow
        case .red: return .red
        case .cyan: return .cyan
        }
    }
}

// MARK: - Section Header
struct SectionHeader: View {
    let title: String
    let subtitle: String
    var showChevron: Bool = true
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button(action: { action?() }) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        if showChevron {
                            Image(systemName: "chevron.right")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }
}

// MARK: - Shimmer Modifier
struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.clear,
                            Color.white.opacity(0.4),
                            Color.clear
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 2)
                    .offset(x: -geometry.size.width + (geometry.size.width * 2 * phase))
                }
            )
            .mask(content)
            .onAppear {
                withAnimation(
                    .linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
                ) {
                    phase = 1
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}

// MARK: - Preview
#Preview {
    MoviesHomeView()
}
