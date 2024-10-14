//
//  CryptoTracker.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-09-19.
//
import Foundation
import Models
import OSLog

extension Logger {
    // swiftlint:disable:next force_unwrapping
    private static let subsystem = Bundle.main.bundleIdentifier!
    static let tracker = Logger(subsystem: subsystem, category: "tracker")
}

public actor UpdateCurrencies {
    private var session = URLSession.shared
    private let quoteAsset: String
    private let repository: CryptoCurrencyRepository
    private let provider: CurrencyRateProviding

    public init(
        repository: CryptoCurrencyRepository,
        provider: CurrencyRateProviding,
        session: URLSession = URLSession.shared,
        quoteAsset: String = "usdt"
    ) {
        self.session = session
        self.quoteAsset = quoteAsset
        self.repository = repository
        self.provider = provider
    }

    public func startUpdating() async {
        Logger.tracker.debug("Fetching task started")
        repeat {
            do {
                for update in try await provider.fetchCurrencies() {
                    let lastPrice = Double(update.lastPrice)
                    guard let lastPrice, update.quoteAsset == quoteAsset else {
                        continue
                    }
                    await repository.update(baseAsset: update.baseAsset, lastPrice: lastPrice)
                }
                try? await Task.sleep(for: .seconds(10))
            } catch {
                Logger.tracker.error("\(error.localizedDescription)")
            }
        } while !Task.isCancelled
        Logger.tracker.debug("Fetching task cancelled")
    }
}
