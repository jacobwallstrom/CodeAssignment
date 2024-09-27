//
//  CodeAssignmentApp.swift
//  CodeAssignment
//
//  Created by Jacob Wallström on 2024-09-18.
//

import Gateways
import Models
import SwiftUI
import UI

@main
struct CodeAssignmentApp: App {
    let dependencies = Dependencies.shared
    @State private var model = PortfolioScreen.ViewModel(portfolios: [Dependencies.shared.samplePortfolio, Dependencies.shared.samplePortfolio2], currency: .usd)

    var body: some Scene {
        WindowGroup {
            PortfolioScreen(model: model)
                .task {
                    await dependencies.tracker.startUpdating()
                }
                .environment(dependencies.repository)
                .tint(.orange)
        }
    }
}

@MainActor
class Dependencies {
    lazy var repository = CryptoCurrencyRepository.defaultValue
    lazy var tracker = WazirxTracker(repository: repository)
    lazy var btc = repository.getCurrency("btc")
    lazy var eth = repository.getCurrency("eth")
    lazy var samplePortfolio = Portfolio(
        name: "Jacob",
        holdings: [
            Holding(crypto: btc, amount: 0.2, cost: 11120.68),
            Holding(crypto: eth, amount: 1, cost: 3000)
        ]
    )
    lazy var samplePortfolio2 = Portfolio(
        name: "Marcus",
        holdings: [
            Holding(crypto: btc, amount: 0.2, cost: 11120.68),
            Holding(crypto: eth, amount: 1, cost: 3000),
            Holding(crypto: eth, amount: 2, cost: 3000)
        ]
    )

    static let shared = Dependencies()

    private init() {}
}
