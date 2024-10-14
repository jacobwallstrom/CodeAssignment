//
//  CurrencyRateUpdate.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-10-14.
//
import Foundation

public struct CurrencyRateUpdate: Sendable, Codable {
    let baseAsset: String
    var quoteAsset: String
    var lastPrice: String
}

public protocol CurrencyRateProviding: Sendable {
    func fetchCurrencies() async throws -> [CurrencyRateUpdate]
}
