//
//  CryptoCurrency.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-09-19.
//
import Foundation
import Observation

@Observable @MainActor
public final class CryptoCurrency {
    public let baseAsset: String
    public var lastPrice: Double?

    public init(baseAsset: String, quoteAsset _: String = "usdt", lastPrice: Double? = nil) {
        self.baseAsset = baseAsset
        self.lastPrice = lastPrice
    }
}

public extension CryptoCurrency {
    static let mockBtc = CryptoCurrency(
        baseAsset: "BTC",
        lastPrice: 64693
    )

    static let mockEth = CryptoCurrency(
        baseAsset: "ETH",
        lastPrice: 3435.89
    )

    static let noPrice = CryptoCurrency(
        baseAsset: "XXX"
    )
}
