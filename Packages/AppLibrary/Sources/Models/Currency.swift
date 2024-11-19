//
//  Currency.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-09-19.
//
import Observation

public enum Currency: String, Sendable, CaseIterable, Codable {
    case usd
    case sek

    public var currentValuePerUSD: Double {
        switch self {
        case .usd: 1.0
        case .sek: 10.00
        }
    }

    public var code: String { rawValue.uppercased() }
}

extension Currency: Identifiable {
    public var id: String { rawValue }
}
