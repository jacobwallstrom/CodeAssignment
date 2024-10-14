//
//  WazirRateProvider.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-10-14.
//
import Foundation
import UseCases

public final class WazirRateProvider: CurrencyRateProviding {
    private let session = URLSession.shared

    public init() {}

    public func fetchCurrencies() async throws -> [CurrencyRateUpdate] {
        // swiftlint:disable:next force_unwrapping
        let url = URL(string: "https://api.wazirx.com/sapi/v1/tickers/24hr")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        return try await session.fetch(request)
    }
}
