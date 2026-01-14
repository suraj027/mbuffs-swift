//
//  PosterCardComponents.swift
//  mbuffs
//
//  Created by AI Assistant on 14/01/26.
//

import SwiftUI

// MARK: - Large Poster Card (Featured/Theatrical)
/// Used for theatrical releases - large cards with title overlay
struct LargePosterCard: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Poster Image
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
            
            // Title & Description
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
/// Used for streaming, coming soon, and explore sections
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
/// Used for streaming provider logos
struct NetworkCard: View {
    let network: StreamingNetwork
    
    var body: some View {
        VStack(spacing: 8) {
            // Logo Container
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
            
            // Network Name
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
/// Colorful pill button for genres
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
/// Reusable section header with title, subtitle, and chevron
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

// MARK: - Previews
#Preview("Large Poster Card") {
    LargePosterCard(movie: Movie(
        id: 1,
        title: "The Housemaid",
        overview: "Trying to escape her past, Millie Calloway accepts a job as a live-in housemaid...",
        posterPath: "/i9LKqjFYOJG6wYmlxQYbT2Xoqvh.jpg",
        backdropPath: nil,
        voteAverage: 7.8,
        releaseDate: "2025-12-25"
    ))
    .padding()
}

#Preview("Medium Poster Card") {
    MediumPosterCard(movie: Movie(
        id: 1,
        title: "Wicked",
        overview: "The untold story...",
        posterPath: "/kMe6TshEFuPGqLr4tJe2u4TK2ja.jpg",
        backdropPath: nil,
        voteAverage: 8.4,
        releaseDate: "2024-11-22"
    ), showTitle: true)
    .padding()
}

#Preview("Genre Button") {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
        GenreButton(genre: Genre(id: 28, name: "Action", color: .blue))
        GenreButton(genre: Genre(id: 12, name: "Adventure", color: .green))
        GenreButton(genre: Genre(id: 35, name: "Comedy", color: .orange))
        GenreButton(genre: Genre(id: 27, name: "Horror", color: .red))
    }
    .padding()
}
