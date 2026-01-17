//
//  TVShowGridView.swift
//  mbuffs
//
//  Created by AI Assistant on 17/01/26.
//

import SwiftUI

/// A grid view displaying all TV shows for a specific category
struct TVShowGridView: View {
    let title: String
    let shows: [TVShow]
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 16) {
                if shows.isEmpty {
                    // Show skeleton placeholders when no shows
                    ForEach(0..<12, id: \.self) { _ in
                        SkeletonTVGridCard()
                    }
                } else {
                    ForEach(shows) { show in
                        NavigationLink(destination: TVShowDetailsView(show: show)) {
                            TVGridPosterCard(posterURL: show.posterURL)
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

// MARK: - TV Grid Poster Card
/// A simple poster card for the TV show grid view
struct TVGridPosterCard: View {
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
                Image(systemName: "tv")
                    .font(.title2)
                    .foregroundColor(.gray)
            )
    }
}

// MARK: - Skeleton TV Grid Card
struct SkeletonTVGridCard: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.2))
            .aspectRatio(2/3, contentMode: .fit)
            .tvShimmer()
    }
}

#Preview {
    NavigationStack {
        TVShowGridView(
            title: "Currently Streaming",
            shows: []
        )
    }
}
