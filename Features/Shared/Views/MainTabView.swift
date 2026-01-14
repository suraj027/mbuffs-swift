//
//  MainTabView.swift
//  mbuffs
//
//  Created by AI Assistant on 14/01/26.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 1 // Start on Movies
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Main navigation tabs
            Tab("Discover", systemImage: "star.fill", value: 0) {
                DiscoverView()
            }
            
            Tab("Movies", systemImage: "film.stack", value: 1) {
                MoviesHomeView()
            }
            
            Tab("Shows", systemImage: "play.rectangle.fill", value: 2) {
                TVShowsHomeView()
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
                VStack(spacing: 20) {
                    Text("Discover Content")
                        .font(.title)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 100)
            }
            .navigationTitle("Discover")
        }
    }
}

struct LibraryView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Your Library")
                        .font(.title)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 100)
            }
            .navigationTitle("Library")
        }
    }
}

struct SearchView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Search for movies and shows...")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(uiColor: .systemBackground))
            .navigationTitle("Search")
            .searchable(text: $searchText, prompt: "Movies, shows, people...")
        }
    }
}

#Preview {
    MainTabView()
}


