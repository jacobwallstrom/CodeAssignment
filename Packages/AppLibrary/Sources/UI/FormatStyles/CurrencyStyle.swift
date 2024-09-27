//
//  CurrencyStyle.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-09-23.
//
import Models
import SwiftUI

public extension FormatStyle where Self == FloatingPointFormatStyle<Double>.Currency {
    static func currencyStyle(_ currency: Models.Currency) -> FloatingPointFormatStyle<Double>.CurrencyStyle {
        FloatingPointFormatStyle.CurrencyStyle(currency: currency)
    }
}

public extension FloatingPointFormatStyle {
    struct CurrencyStyle: FormatStyle {
        let currency: Models.Currency
        public typealias FormatInput = Double
        public typealias FormatOutput = String

        public func format(_ value: Double) -> String {
            (value * currency.currentValuePerUSD)
                .formatted(baseStyle)
        }

        private var baseStyle: FloatingPointFormatStyle<Double>.Currency {
            .currency(code: currency.code)
                .presentation(.narrow)
                .locale(.current)
        }
    }
}
