//
//  Dependencies.swift
//  CodeAssignment
//
//  Created by Jacob Wallström on 2024-11-20.
//
import Infrastructure
import UseCases
import Models

@MainActor
class Dependencies {
    static let shared = Dependencies()

    lazy var repository = CryptoCurrencyRepository.defaultValue
    lazy var provider = WazirRateProvider()
    lazy var tracker = UpdateCurrencies(repository: repository, provider: provider)
    lazy var btc = repository.getCurrency("btc")
    lazy var eth = repository.getCurrency("eth")
    lazy var samplePortfolio = Portfolio(
        name: "Jacob",
        holdings: [
            Holding(crypto: btc, amount: 0.2, cost: 11120.68),
            Holding(crypto: eth, amount: 1, cost: 3000),
        ]
    )
    lazy var samplePortfolio2 = Portfolio(
        name: "Marcus",
        holdings: [
            Holding(crypto: btc, amount: 0.2, cost: 11120.68),
            Holding(crypto: eth, amount: 1, cost: 3000),
            Holding(crypto: eth, amount: 2, cost: 3000),
        ]
    )

    private init() {}
}
