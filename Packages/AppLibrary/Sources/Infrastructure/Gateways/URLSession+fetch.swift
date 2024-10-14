//
//  URLSession+fetch.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-10-14.
//
import Foundation

extension URLSession {
    enum Errors: Error {
        case badStatus(Int)
    }

    @MainActor private static var decoder = {
        let result = JSONDecoder()
        result.dateDecodingStrategy = .millisecondsSince1970
        return result
    }()

    nonisolated func fetch<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, response) = try await data(for: request)
        guard let response = response as? HTTPURLResponse else {
            fatalError("Only HTTP implemented")
        }
        guard response.statusCode % 100 != 2 else {
            throw Errors.badStatus(response.statusCode)
        }
        return try await Self.decoder.decode(T.self, from: data)
    }
}
