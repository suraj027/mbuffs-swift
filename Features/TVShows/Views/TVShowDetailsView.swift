//
//  TVShowDetailsView.swift
//  mbuffs
//
//  Created by AI Assistant on 14/01/26.
//

import SwiftUI

struct TVShowDetailsView: View {
    let show: TVShow
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header Image with Parallax-style overlay
                ZStack(alignment: .bottomLeading) {
                    AsyncImage(url: show.backdropURL ?? show.posterURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle().fill(Color.gray.opacity(0.3))
                    }
                    .frame(height: 450)
                    .clipped()
                    .overlay(
                        LinearGradient(
                            colors: [.black.opacity(0.6), .clear],
                            startPoint: .bottom,
                            endPoint: .center
                        )
                    )
                    
                    // Glass Info Card floating at bottom of header
                    VStack(alignment: .leading, spacing: 8) {
                        Text(show.name)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 12) {
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill").foregroundColor(.yellow)
                                Text(String(format: "%.1f", show.voteAverage))
                                    .fontWeight(.semibold)
                            }
                            
                            if let date = show.firstAirDate {
                                Text("•")
                                Text(date.prefix(4))
                            }
                            
                            Text("•")
                            Text("Drama, Thriller") // Mock Genre
                        }
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .mask(
                                LinearGradient(colors: [.black, .black.opacity(0)], startPoint: .bottom, endPoint: .top)
                            )
                    )
                }
                
                // Content Body
                VStack(alignment: .leading, spacing: 24) {
                    // Actions
                    HStack(spacing: 20) {
                        Button(action: {}) {
                            Label("Watch S1 E1", systemImage: "play.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button(action: {}) {
                            Image(systemName: "plus")
                                .font(.title3)
                                .frame(width: 50, height: 50)
                        }
                        .buttonStyle(.bordered)
                        .tint(.primary)
                    }
                    
                    // Storyline
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Storyline")
                            .font(.title3.bold())
                        
                        Text(show.overview)
                            .font(.body)
                            .lineSpacing(6)
                            .foregroundColor(.secondary)
                    }
                    
                    // Cast (Mock)
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Cast")
                            .font(.title3.bold())
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(0..<5) { _ in
                                    VStack {
                                        Circle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 70, height: 70)
                                        Text("Actor Name")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(24)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(.ultraThinMaterial, in: Circle())
                }
            }
        }
    }
}
