//
//  CryptoTracker.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-09-19.
//
import Foundation
import Models
import OSLog

private let logger = Logger(subsystem: "CryptoTracker", category: "tracker")

public actor WazirxTracker {
    private var session = URLSession.shared
    private let quoteAsset: String
    private let repository: CryptoCurrencyRepository

    struct CryptoUpdate: Decodable {
        let baseAsset: String
        var quoteAsset: String
        var lastPrice: String
    }

    public init(repository: CryptoCurrencyRepository, quoteAsset: String = "usdt") {
        self.quoteAsset = quoteAsset
        self.repository = repository
    }

    public func startUpdating() async {
        logger.debug("Fetching task started")
        repeat {
            do {
                for update in try await fetchCurrencies() {
                    let lastPrice = Double(update.lastPrice)
                    guard let lastPrice, update.quoteAsset == quoteAsset else {
                        continue
                    }
                    await repository.update(baseAsset: update.baseAsset, lastPrice: lastPrice)
                }
                try? await Task.sleep(for: .seconds(10))
            } catch {
                logger.error("\(error.localizedDescription)")
            }
        } while !Task.isCancelled
        logger.debug("Fetching task cancelled")
    }

    func fetchCurrencies() async throws -> [CryptoUpdate] {
        let url = URL(string: "https://api.wazirx.com/sapi/v1/tickers/24hr")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        return try await session.fetch(request)
    }
}

extension URLSession {
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

    enum Errors: Error {
        case badStatus(Int)
    }
}
