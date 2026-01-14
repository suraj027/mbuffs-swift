//
//  TVShowsHomeView.swift
//  mbuffs
//
//  Created by AI Assistant on 14/01/26.
//

import SwiftUI

struct TVShowsHomeView: View {
    @StateObject private var viewModel = TVShowsViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 28) {
                    // Currently Streaming Section (Large Cards)
                    currentlyStreamingSection
                    
                    // Airing Today Section
                    airingTodaySection
                    
                    // Popular Shows Section
                    popularShowsSection
                    
                    // Coming Soon Section
                    comingSoonSection
                    
                    // Networks Section
                    networksSection
                    
                    // Genres Section
                    genresSection
                }
                .padding(.top, 8)
                .padding(.bottom, 100) // Space for TabBar
            }
            .background(Color(uiColor: .systemBackground))
            .navigationTitle("Shows")
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
    
    // MARK: - Currently Streaming (Large Cards)
    private var currentlyStreamingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            TVSectionHeader(
                title: "Currently Streaming",
                subtitle: "Discover your next watch"
            )
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.currentlyStreaming) { show in
                        NavigationLink(destination: TVShowDetailsView(show: show)) {
                            LargeTVPosterCard(show: show)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Airing Today
    private var airingTodaySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            TVSectionHeader(
                title: "Airing Today",
                subtitle: "Stay up to date"
            )
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.airingToday) { show in
                        NavigationLink(destination: TVShowDetailsView(show: show)) {
                            MediumTVPosterCard(show: show)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Popular Shows
    private var popularShowsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            TVSectionHeader(
                title: "Popular Shows",
                subtitle: "Popular and trending shows"
            )
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.popularShows) { show in
                        NavigationLink(destination: TVShowDetailsView(show: show)) {
                            MediumTVPosterCard(show: show)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Coming Soon
    private var comingSoonSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            TVSectionHeader(
                title: "Coming Soon",
                subtitle: "New and upcoming shows"
            )
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.comingSoon) { show in
                        NavigationLink(destination: TVShowDetailsView(show: show)) {
                            MediumTVPosterCard(show: show)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Networks
    private var networksSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            TVSectionHeader(
                title: "Networks",
                subtitle: "Available watch providers"
            )
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.networks) { network in
                        TVNetworkCard(network: network)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Genres
    private var genresSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            TVSectionHeader(
                title: "Genres",
                subtitle: "Shows by genre",
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
                        TVGenreButton(genre: genre)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Large TV Poster Card (Featured/Currently Streaming)
struct LargeTVPosterCard: View {
    let show: TVShow
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: show.posterURL) { phase in
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
                Text(show.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(show.overview)
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
                Image(systemName: "tv")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            )
    }
}

// MARK: - Medium TV Poster Card
struct MediumTVPosterCard: View {
    let show: TVShow
    let showTitle: Bool
    
    init(show: TVShow, showTitle: Bool = false) {
        self.show = show
        self.showTitle = showTitle
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            AsyncImage(url: show.posterURL) { phase in
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
                Text(show.name)
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
                Image(systemName: "tv")
                    .font(.title2)
                    .foregroundColor(.gray)
            )
    }
}

// MARK: - TV Network Card
struct TVNetworkCard: View {
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

// MARK: - TV Genre Button
struct TVGenreButton: View {
    let genre: TVGenre
    
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
        case .purple: return .purple
        case .orange: return .orange
        case .teal: return .teal
        case .gray: return .gray
        case .pink: return .pink
        case .mint: return .mint
        case .yellow: return .yellow
        case .indigo: return .indigo
        case .coral: return Color(red: 1.0, green: 0.42, blue: 0.42)
        case .green: return .green
        case .brown: return .brown
        case .cyan: return .cyan
        case .red: return .red
        }
    }
}

// MARK: - TV Section Header
struct TVSectionHeader: View {
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

// MARK: - Preview
#Preview {
    TVShowsHomeView()
}
