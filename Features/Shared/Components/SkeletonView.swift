//
//  SkeletonView.swift
//  mbuffs
//
//  Created by AI Assistant on 15/01/26.
//

import SwiftUI

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

// MARK: - Skeleton Poster Card (Large)
struct SkeletonLargePosterCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Poster Skeleton
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 280, height: 420)
                .shimmer()
            
            // Title Skeleton
            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 180, height: 16)
                    .shimmer()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 250, height: 12)
                    .shimmer()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 200, height: 12)
                    .shimmer()
            }
            .frame(width: 280, alignment: .leading)
        }
    }
}

// MARK: - Skeleton Poster Card (Medium)
struct SkeletonMediumPosterCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 140, height: 210)
                .shimmer()
        }
    }
}

// MARK: - Skeleton Network Card
struct SkeletonNetworkCard: View {
    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 70, height: 70)
                .shimmer()
            
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 60, height: 10)
                .shimmer()
        }
    }
}

// MARK: - Skeleton Genre Button
struct SkeletonGenreButton: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 14)
            .fill(Color.gray.opacity(0.15))
            .frame(height: 48)
            .shimmer()
    }
}

// MARK: - Skeleton Section (Large Cards)
struct SkeletonLargeCardsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header Skeleton
            VStack(alignment: .leading, spacing: 4) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 180, height: 20)
                    .shimmer()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 220, height: 14)
                    .shimmer()
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

// MARK: - Skeleton Section (Medium Cards)
struct SkeletonMediumCardsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header Skeleton
            VStack(alignment: .leading, spacing: 4) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 160, height: 20)
                    .shimmer()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 200, height: 14)
                    .shimmer()
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

// MARK: - Skeleton Networks Section
struct SkeletonNetworksSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header Skeleton
            VStack(alignment: .leading, spacing: 4) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 100, height: 20)
                    .shimmer()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 180, height: 14)
                    .shimmer()
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

// MARK: - Skeleton Genres Section
struct SkeletonGenresSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header Skeleton
            VStack(alignment: .leading, spacing: 4) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 80, height: 20)
                    .shimmer()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 140, height: 14)
                    .shimmer()
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
#Preview("Skeleton Large Card") {
    SkeletonLargePosterCard()
        .padding()
}

#Preview("Skeleton Section") {
    VStack(spacing: 28) {
        SkeletonLargeCardsSection()
        SkeletonMediumCardsSection()
    }
}
