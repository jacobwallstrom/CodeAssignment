//
//  Portfolio.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-09-19.
//
import Observation

@Observable @MainActor
public class Portfolio: Identifiable {
    public var name: String
    public var holdings: [Holding]

    public var currentValue: Double? {
        holdings.reduce(0) { (result: Double?, holding: Holding) in
            guard let result, let currentValue = holding.currentValue else { return nil }
            return result + currentValue
        }
    }

    public var change: Double? {
        guard let currentValue else { return nil }
        return currentValue - cost
    }

    public var relativeChange: Double? {
        guard let change else { return nil }
        return change / cost
    }

    public var cost: Double {
        holdings.reduce(0) { (result: Double, holding: Holding) in
            result + holding.cost
        }
    }

    public var description: String {
        let holdingsText = holdings
            .map { "\($0.crypto.baseAsset) \($0.amount) \($0.cost) \($0.currentValue?.description ?? "nil")" }
        return "\(name): \(holdingsText)"
    }

    public init(name: String, holdings: [Holding]) {
        self.name = name
        self.holdings = holdings
    }
}

public extension Portfolio {
    static let mock = Portfolio(
        name: "Jacob",
        holdings: [
            Holding.mock1,
            Holding.mock2,
        ]
    )
}
