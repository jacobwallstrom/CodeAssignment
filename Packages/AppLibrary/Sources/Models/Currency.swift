//
//  Currency.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-09-19.
//
import SwiftUI

public enum Currency: String, Sendable, CaseIterable, Codable {
    case usd
    case sek

    public var currentValuePerUSD: Double {
        switch self {
        case .usd: 1.0
        case .sek: 10.13
        }
    }

    public var code: String { rawValue.uppercased() }
}

extension Currency: Identifiable {
    public var id: String { rawValue }
}

public extension EnvironmentValues {
    var currency: Currency {
        get { self[CurrencyKey.self] } set {
            self[CurrencyKey.self] = newValue
        }
    }
}

public struct CurrencyKey: EnvironmentKey {
    public static let defaultValue = Currency.usd
}
