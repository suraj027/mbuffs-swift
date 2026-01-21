//
//  MainTabView.swift
//  mbuffs
//
//  Created by AI Assistant on 14/01/26.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 1 // Start on Movies
    
    // Persist ViewModels at parent level to prevent re-fetching on tab switches
    @StateObject private var moviesViewModel = MoviesViewModel()
    @StateObject private var tvShowsViewModel = TVShowsViewModel()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Main navigation tabs
            Tab("Discover", systemImage: "star.fill", value: 0) {
                DiscoverView()
            }
            
            Tab("Movies", systemImage: "film.stack", value: 1) {
                MoviesHomeView(viewModel: moviesViewModel)
            }
            
            Tab("Shows", systemImage: "play.rectangle.fill", value: 2) {
                TVShowsHomeView(viewModel: tvShowsViewModel)
            }
            
            Tab("Library", systemImage: "books.vertical", value: 3) {
                LibraryView()
            }
            
            // Search tab with .search role - appears separately at trailing end
            Tab(value: 4, role: .search) {
                SearchView()
            }
        }
        .tint(.primary)
    }
}

// MARK: - Placeholder Views
struct DiscoverView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Discover Content")
                        .font(.title)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 100)
            }
            .safeAreaBar(edge: .top) {
                Text("Discover")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            }
            .navigationBarHidden(true)
        }
    }
}

struct LibraryView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Your Library")
                        .font(.title)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 100)
            }
            .safeAreaBar(edge: .top) {
                Text("Library")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            }
            .navigationBarHidden(true)
        }
    }
}

struct SearchView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Search for movies and shows...")
                        .font(.title2)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 100)
            }
            .safeAreaBar(edge: .top) {
                Text("Search")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            }
            .navigationBarHidden(true)
            .searchable(text: $searchText, prompt: "Movies, shows, people...")
        }
    }
}

#Preview {
    MainTabView()
}
