//
//  TVShowsHomeView.swift
//  mbuffs
//
//  Created by AI Assistant on 14/01/26.
//

import SwiftUI

// MARK: - TV Scroll Offset Preference Key
struct TVScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct TVShowsHomeView: View {
    @StateObject private var viewModel = TVShowsViewModel()
    @State private var scrollOffset: CGFloat = 0
    
    private let collapsedThreshold: CGFloat = 50
    
    private var isCollapsed: Bool {
        scrollOffset > collapsedThreshold
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // Main scrollable content
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 28) {
                        if viewModel.isLoading {
                            // Skeleton Loading State
                            SkeletonLargeCardsSection()
                            SkeletonMediumCardsSection()
                            SkeletonMediumCardsSection()
                            SkeletonMediumCardsSection()
                            SkeletonNetworksSection()
                            SkeletonGenresSection()
                        } else {
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
                    }
                    .padding(.bottom, 100) // Space for TabBar
                    .background(
                        GeometryReader { geo in
                            Color.clear.preference(
                                key: TVScrollOffsetPreferenceKey.self,
                                value: -geo.frame(in: .named("tvscroll")).origin.y
                            )
                        }
                    )
                }
                .coordinateSpace(name: "tvscroll")
                .onPreferenceChange(TVScrollOffsetPreferenceKey.self) { value in
                    scrollOffset = value
                }
                .safeAreaBar(edge: .top) {
                    Text("Shows")
                        .font(isCollapsed ? .headline : .largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .animation(.easeInOut(duration: 0.2), value: isCollapsed)
                }
            }
            .navigationBarHidden(true)
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
                    if viewModel.currentlyStreaming.isEmpty {
                        ForEach(0..<3, id: \.self) { _ in
                            SkeletonLargePosterCard()
                        }
                    } else {
                        ForEach(viewModel.currentlyStreaming) { show in
                            NavigationLink(destination: TVShowDetailsView(show: show)) {
                                LargeTVPosterCard(show: show)
                            }
                            .buttonStyle(.plain)
                        }
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
                    if viewModel.airingToday.isEmpty {
                        ForEach(0..<5, id: \.self) { _ in
                            SkeletonMediumPosterCard()
                        }
                    } else {
                        ForEach(viewModel.airingToday) { show in
                            NavigationLink(destination: TVShowDetailsView(show: show)) {
                                MediumTVPosterCard(show: show)
                            }
                            .buttonStyle(.plain)
                        }
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
                    if viewModel.popularShows.isEmpty {
                        ForEach(0..<5, id: \.self) { _ in
                            SkeletonMediumPosterCard()
                        }
                    } else {
                        ForEach(viewModel.popularShows) { show in
                            NavigationLink(destination: TVShowDetailsView(show: show)) {
                                MediumTVPosterCard(show: show)
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
            TVSectionHeader(
                title: "Coming Soon",
                subtitle: "New and upcoming shows"
            )
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    if viewModel.comingSoon.isEmpty {
                        ForEach(0..<5, id: \.self) { _ in
                            SkeletonMediumPosterCard()
                        }
                    } else {
                        ForEach(viewModel.comingSoon) { show in
                            NavigationLink(destination: TVShowDetailsView(show: show)) {
                                MediumTVPosterCard(show: show)
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

// MARK: - Shimmer Modifier (TV)
struct TVShimmerModifier: ViewModifier {
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
    func tvShimmer() -> some View {
        modifier(TVShimmerModifier())
    }
}

// MARK: - Skeleton Poster Card (Large) - TV
struct SkeletonLargePosterCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 280, height: 420)
                .overlay(
                    Image(systemName: "tv")
                        .font(.system(size: 40))
                        .foregroundColor(.gray.opacity(0.4))
                )
                .tvShimmer()
            
            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 180, height: 16)
                    .tvShimmer()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 250, height: 12)
                    .tvShimmer()
            }
            .frame(width: 280, alignment: .leading)
        }
    }
}

// MARK: - Skeleton Poster Card (Medium) - TV
struct SkeletonMediumPosterCard: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.2))
            .frame(width: 140, height: 210)
            .overlay(
                Image(systemName: "tv")
                    .font(.system(size: 28))
                    .foregroundColor(.gray.opacity(0.4))
            )
            .tvShimmer()
    }
}

// MARK: - Skeleton Network Card - TV
struct SkeletonNetworkCard: View {
    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 70, height: 70)
                .tvShimmer()
            
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 60, height: 10)
                .tvShimmer()
        }
    }
}

// MARK: - Skeleton Genre Button - TV
struct SkeletonGenreButton: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 14)
            .fill(Color.gray.opacity(0.15))
            .frame(height: 48)
            .tvShimmer()
    }
}

// MARK: - Skeleton Section (Large Cards) - TV
struct SkeletonLargeCardsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 180, height: 20)
                    .tvShimmer()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 220, height: 14)
                    .tvShimmer()
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<3, id: \.self) { _ in
                        SkeletonLargePosterCard()
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Skeleton Section (Medium Cards) - TV
struct SkeletonMediumCardsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 160, height: 20)
                    .tvShimmer()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 200, height: 14)
                    .tvShimmer()
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(0..<5, id: \.self) { _ in
                        SkeletonMediumPosterCard()
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Skeleton Networks Section - TV
struct SkeletonNetworksSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 100, height: 20)
                    .tvShimmer()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 180, height: 14)
                    .tvShimmer()
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<6, id: \.self) { _ in
                        SkeletonNetworkCard()
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Skeleton Genres Section - TV
struct SkeletonGenresSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 80, height: 20)
                    .tvShimmer()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 140, height: 14)
                    .tvShimmer()
            }
            .padding(.horizontal)
            
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ],
                spacing: 12
            ) {
                ForEach(0..<8, id: \.self) { _ in
                    SkeletonGenreButton()
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Preview
#Preview {
    TVShowsHomeView()
}
