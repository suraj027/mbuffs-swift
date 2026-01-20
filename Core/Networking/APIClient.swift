//
//  APIClient.swift
//  mbuffs
//
//  Created by AI Assistant on 14/01/26.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
    case serverError(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .requestFailed(let error):
            return "Request failed: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingFailed(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .serverError(let code):
            return "Server error with code: \(code)"
        }
    }
}

protocol APIClientProtocol {
    func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

class APIClient: APIClientProtocol {
    static let shared = APIClient()
    private let session: URLSession
    
    // Custom TMDB API Server
    private let baseURL = "https://tmdb-api-rouge.vercel.app"

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        guard let url = endpoint.url(baseURL: baseURL) else {
            throw APIError.invalidURL
        }
        
        print("🌐 Fetching: \(url.absoluteString)")

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(httpResponse.statusCode)
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            print("❌ Decoding error: \(error)")
            throw APIError.decodingFailed(error)
        }
    }
}
