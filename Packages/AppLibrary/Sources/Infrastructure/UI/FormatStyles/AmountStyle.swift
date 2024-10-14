//
//  AmountStyle.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-09-23.
//
import Models
import SwiftUI

public extension FormatStyle where Self == FloatingPointFormatStyle<Double> {
    static func amountStyle(_ currency: Models.Currency) -> FloatingPointFormatStyle<Double>.AmountStyle {
        FloatingPointFormatStyle.AmountStyle(currency: currency)
    }
}

public extension FloatingPointFormatStyle {
    struct AmountStyle: ParseableFormatStyle {
        public var parseStrategy: AmountStyleParseStrategy
        let currency: Models.Currency

        public typealias FormatInput = Double
        public typealias FormatOutput = String

        init(currency: Models.Currency) {
            parseStrategy = AmountStyleParseStrategy(currency: currency)
            self.currency = currency
        }

        public func format(_ value: Double) -> String {
            (value * currency.currentValuePerUSD)
                .formatted(baseStyle)
        }

        public struct AmountStyleParseStrategy: ParseStrategy {
            let currency: Models.Currency

            public func parse(_ value: String) throws -> Double {
                let parsedValue = try baseStyle.parseStrategy.parse(value)
                return parsedValue / currency.currentValuePerUSD
            }

            private var baseStyle: FloatingPointFormatStyle<Double> {
                .number
                    .locale(.current)
            }
        }

        private var baseStyle: FloatingPointFormatStyle<Double> {
            .number
                .locale(.current)
        }
    }
}
