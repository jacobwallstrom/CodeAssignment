//
//  CodeAssignmentApp.swift
//  CodeAssignment
//
//  Created by Jacob Wallström on 2024-09-18.
//

import SwiftUI
import UI
import Gateways
import Models

@main
struct CodeAssignmentApp: App {
	let dependencies = Dependencies.shared
	@State var portfolios: [Portfolio]
	@State private var currency = Currency.usd

	init() {
		_portfolios = State(initialValue: [dependencies.samplePortfolio])
	}

	var body: some Scene {
        WindowGroup {
			PortfolioScreen(portfolios: $portfolios, currency: $currency)
				.task {
					await dependencies.tracker.startUpdating()
				}
				.environment(dependencies.repository)
				.environment(\.currency, currency)
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

	static let shared = Dependencies()

	private init() {}
}

