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

// MARK: - Scroll Preference Keys for Tab Views
struct DiscoverScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct LibraryScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct SearchScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Placeholder Views
struct DiscoverView: View {
    @State private var scrollOffset: CGFloat = 0
    private let collapsedThreshold: CGFloat = 50
    
    private var isCollapsed: Bool {
        scrollOffset > collapsedThreshold
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Spacer for header
                        Color.clear
                            .frame(height: 50)
                        
                        Text("Discover Content")
                            .font(.title)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 100)
                    .background(
                        GeometryReader { geo in
                            Color.clear.preference(
                                key: DiscoverScrollOffsetKey.self,
                                value: -geo.frame(in: .named("discoverScroll")).origin.y
                            )
                        }
                    )
                }
                .coordinateSpace(name: "discoverScroll")
                .onPreferenceChange(DiscoverScrollOffsetKey.self) { value in
                    scrollOffset = value
                }
                
                // Sticky header with progressive blur
                VStack(spacing: 0) {
                    HStack {
                        Text("Discover")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .padding(.bottom, 12)
                }
                .background(
                    ZStack {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .mask(
                                LinearGradient(
                                    colors: [.white, .white, .white.opacity(0)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        Rectangle()
                            .fill(.regularMaterial.opacity(0.6))
                            .mask(
                                LinearGradient(
                                    colors: [.white, .white.opacity(0.5), .clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                    .frame(height: 120)
                    .ignoresSafeArea(edges: .top)
                    , alignment: .top
                )
                .animation(.easeInOut(duration: 0.2), value: isCollapsed)
            }
            .navigationBarHidden(true)
        }
    }
}

struct LibraryView: View {
    @State private var scrollOffset: CGFloat = 0
    private let collapsedThreshold: CGFloat = 50
    
    private var isCollapsed: Bool {
        scrollOffset > collapsedThreshold
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Spacer for header
                        Color.clear
                            .frame(height: 50)
                        
                        Text("Your Library")
                            .font(.title)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 100)
                    .background(
                        GeometryReader { geo in
                            Color.clear.preference(
                                key: LibraryScrollOffsetKey.self,
                                value: -geo.frame(in: .named("libraryScroll")).origin.y
                            )
                        }
                    )
                }
                .coordinateSpace(name: "libraryScroll")
                .onPreferenceChange(LibraryScrollOffsetKey.self) { value in
                    scrollOffset = value
                }
                
                // Sticky header with progressive blur
                VStack(spacing: 0) {
                    HStack {
                        Text("Library")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .padding(.bottom, 12)
                }
                .background(
                    ZStack {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .mask(
                                LinearGradient(
                                    colors: [.white, .white, .white.opacity(0)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        Rectangle()
                            .fill(.regularMaterial.opacity(0.6))
                            .mask(
                                LinearGradient(
                                    colors: [.white, .white.opacity(0.5), .clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                    .frame(height: 120)
                    .ignoresSafeArea(edges: .top)
                    , alignment: .top
                )
                .animation(.easeInOut(duration: 0.2), value: isCollapsed)
            }
            .navigationBarHidden(true)
        }
    }
}

struct SearchView: View {
    @State private var searchText = ""
    @State private var scrollOffset: CGFloat = 0
    private let collapsedThreshold: CGFloat = 50
    
    private var isCollapsed: Bool {
        scrollOffset > collapsedThreshold
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Spacer for header
                        Color.clear
                            .frame(height: 50)
                        
                        Text("Search for movies and shows...")
                            .font(.title2)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 100)
                    .background(
                        GeometryReader { geo in
                            Color.clear.preference(
                                key: SearchScrollOffsetKey.self,
                                value: -geo.frame(in: .named("searchScroll")).origin.y
                            )
                        }
                    )
                }
                .coordinateSpace(name: "searchScroll")
                .onPreferenceChange(SearchScrollOffsetKey.self) { value in
                    scrollOffset = value
                }
                
                // Sticky header with progressive blur
                VStack(spacing: 0) {
                    HStack {
                        if isCollapsed {
                            Spacer()
                        }
                        
                        Text("Search")
                            .font(isCollapsed ? .headline : .largeTitle)
                            .fontWeight(.bold)
                            .animation(.easeInOut(duration: 0.2), value: isCollapsed)
                        
                        if isCollapsed {
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .padding(.bottom, 12)
                    .frame(maxWidth: .infinity, alignment: isCollapsed ? .center : .leading)
                }
                .background(
                    ZStack {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .mask(
                                LinearGradient(
                                    colors: [.white, .white, .white.opacity(0)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        Rectangle()
                            .fill(.regularMaterial.opacity(0.6))
                            .mask(
                                LinearGradient(
                                    colors: [.white, .white.opacity(0.5), .clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                    .frame(height: 120)
                    .ignoresSafeArea(edges: .top)
                    , alignment: .top
                )
                .animation(.easeInOut(duration: 0.2), value: isCollapsed)
            }
            .navigationBarHidden(true)
            .searchable(text: $searchText, prompt: "Movies, shows, people...")
        }
    }
}

#Preview {
    MainTabView()
}


