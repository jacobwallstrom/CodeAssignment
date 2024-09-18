//
//  Holding.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-09-19.
//
import Foundation

@MainActor
public struct Holding: Identifiable, Sendable {
	public var id = UUID()
	public var crypto: CryptoCurrency
	public var amount: Double
	public var cost: Double

	public var currentValue: Double? {
		guard let lastPrice = crypto.lastPrice else { return nil }
		return lastPrice * amount
	}

	public var change: Double? {
		guard let currentValue else { return nil }
		return currentValue - cost
	}

	public var relativeChange: Double? {
		guard let change else { return nil }
		return change/cost
	}

	public init(crypto: CryptoCurrency, amount: Double, cost: Double) {
		self.crypto = crypto
		self.amount = amount
		self.cost = cost
	}
}

public extension Holding {
	static let mock1 = Holding(crypto: .mockBtc, amount: 0.2, cost: 11120.68)
	static let mock2 = Holding(crypto: .mockEth, amount: 1, cost: 3000)
}

