# mbuffs – Master Build Plan (Swift / SwiftUI)

mbuffs is a **native iOS movie & TV show tracking app** built using **Swift + SwiftUI**.
The app prioritizes **iOS 26 Liquid Glass aesthetics**, smooth gestures, and system-native behavior.

This document defines:
- What we are building
- How it is architected in SwiftUI
- The exact build order
- Guardrails for AI-assisted development (Antigravity / Xcode AI)

---

## 1. Product Overview

**mbuffs** allows users to:
- Discover movies and TV shows
- View release dates, ratings, trailers, and metadata
- Add movies/shows to a watchlist
- Track watched content
- Receive and send recommendations to friends (future phase)

Design goals:
- 100% SwiftUI-native
- Liquid Glass UI (blur, vibrancy, depth)
- Zero “cross-platform” compromises
- Fast startup and smooth scrolling

---

## 2. Platform & Tech Stack

### Platform
- iOS only (for now)

### Language & Frameworks
- Swift
- SwiftUI
- Swift Concurrency (`async/await`)
- Combine (only if needed)
- AVKit (trailers)
- UIKit interop only when required

### Architecture
- MVVM (lightweight, SwiftUI-friendly)
- Feature-based folder structure
- Dependency injection via environment

---

## 3. Navigation Architecture (SwiftUI-native)

### Primary Navigation
- `TabView` for main tabs
- `NavigationStack` inside each tab

### Main Tabs
- Movies
- Shows
- Library
- Search

Each tab:
- Has its own `NavigationStack`
- Maintains independent navigation state
- Uses large titles + glass headers

---


## 4. Movies Screen (SwiftUI)

Purpose: Browse and discover movies.

Sections:
- Theatrical Releases
- Currently Streaming
- Coming Soon
- Explore (editorial picks)
- Networks
- Genres

Implementation:
- `ScrollView(.vertical)`
- `LazyHStack` for horizontal carousels
- Section headers with navigation links
- Large title + glass background

---

## 5. TV Shows Screen

Purpose: Discover and track TV shows.

Sections:
- Currently Streaming
- Airing Today
- Popular Shows
- Coming Soon
- Networks
- Genres

Structure mirrors Movies screen to ensure consistency and reuse.

---

## 6. Library Screen

Purpose: User’s personal collection.

Sections:
- Watchlist
- Watched
- Favorites
- Recommended by Friends (future)

Notes:
- Local persistence first (SwiftData / CoreData)
- Cloud sync later

---

## 7. Search Screen

Purpose: Universal content discovery.

Features:
- Live search with debounce
- Movies & TV shows
- Recent searches
- Keyboard-first UX
- Smooth transitions to detail views

---

## 8. Detail Screens (Movie / Show)

### Movie Detail View
- Hero poster + backdrop
- Title, rating, release date
- Overview
- Trailer (AVKit)
- Cast & crew
- Similar movies

Actions:
- Add to Watchlist
- Mark as Watched
- Rate
- Recommend (future)

### TV Show Detail View
- Seasons & episodes
- Airing status
- Similar shows

Navigation:
- Uses `NavigationStack`
- Supports swipe-back
- Smooth hero transitions (matched geometry)

---

## 9. Data Layer

### Backend
- Custom backend proxies TMDB
- App never calls TMDB directly

### Networking
- `URLSession`
- `async/await`
- Strongly typed responses


Caching:
- In-memory cache
- Optional disk cache
- SwiftUI-friendly observable models

---

## 10. Liquid Glass UI System

### Principles
- Blur, not borders
- Depth, not shadows
- Motion, not decoration

### Components
- GlassHeader
- GlassTabBar
- GlassCard
- FloatingActionButton

Implementation:
- `Material.ultraThin`
- `background(.regularMaterial)`
- Dynamic opacity on scroll
- Stretch effects for hero headers

---

## 11. State Management

### View State
- `@State`
- `@StateObject`
- `@Observable` (latest Swift)

### Shared State
- Environment objects (minimal)
- No global singletons unless necessary

Rule:
> If SwiftUI can manage it, let SwiftUI manage it.

---

## 12. Performance Rules (Strict)

- `LazyVStack` / `LazyHStack` only
- Image size matched to layout
- Avoid heavy view recomputation
- No blocking work on main thread
- Async image loading with placeholders

---

## 13. Development Phases

### Phase 1 – Core App
- Movies tab
- Shows tab
- Library (watchlist)
- Search
- Detail screens
- Backend integration

### Phase 2 – Social
- User profiles
- Friends
- Recommendations
- Activity feed

### Phase 3 – Delight
- Smart suggestions
- Mood-based discovery
- AI summaries (optional)

---

## 14. Antigravity / AI Rules (Xcode)

When using AI inside Xcode:
- Modify one feature at a time
- Never refactor multiple screens at once
- Always explain architectural changes
- Prefer SwiftUI-native solutions
- Avoid UIKit unless justified

---

## 15. Definition of Done

mbuffs is successful when:
- It feels like an Apple-built app
- Scrolling is fluid and natural
- UI feels light, not dense
- Codebase remains readable after months
- Features can evolve without rewrites

---

End of Plan.


