//
//  MovieGridView.swift
//  mbuffs
//
//  Created by AI Assistant on 17/01/26.
//

import SwiftUI

/// A grid view displaying all movies for a specific category
struct MovieGridView: View {
    let title: String
    let movies: [Movie]
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 16) {
                if movies.isEmpty {
                    // Show skeleton placeholders when no movies
                    ForEach(0..<12, id: \.self) { _ in
                        SkeletonGridCard()
                    }
                } else {
                    ForEach(movies) { movie in
                        NavigationLink(destination: MovieDetailsView(movie: movie)) {
                            GridPosterCard(posterURL: movie.posterURL)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 16)
            .padding(.bottom, 100) // Space for TabBar
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Grid Poster Card
/// A simple poster card for the grid view
struct GridPosterCard: View {
    let posterURL: URL?
    
    var body: some View {
        AsyncImage(url: posterURL) { phase in
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
        .frame(maxWidth: .infinity)
        .aspectRatio(2/3, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
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

// MARK: - Skeleton Grid Card
struct SkeletonGridCard: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.2))
            .aspectRatio(2/3, contentMode: .fit)
            .shimmer()
    }
}

#Preview {
    NavigationStack {
        MovieGridView(
            title: "Theatrical Releases",
            movies: []
        )
    }
}
