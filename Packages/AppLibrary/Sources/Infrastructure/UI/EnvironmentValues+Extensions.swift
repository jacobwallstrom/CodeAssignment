//
//  EnvironmentValues+Extensions.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-10-13.
//
import Models
import SwiftUI
import UseCases

public extension EnvironmentValues {
    var cryptoCurrencyRepository: CryptoCurrencyRepository {
        get { self[CryptoCurrencyRepository.self] } set {
            self[CryptoCurrencyRepository.self] = newValue
        }
    }
}

extension CryptoCurrencyRepository: EnvironmentKey {
    public nonisolated static let defaultValue = CryptoCurrencyRepository()
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
