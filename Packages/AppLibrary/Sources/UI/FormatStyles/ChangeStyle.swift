//
//  ChangeStyle.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-09-23.
//
import Models
import SwiftUI

public extension FormatStyle where Self == FloatingPointFormatStyle<Double> {
    static func changeStyle(_ currency: Models.Currency) -> FloatingPointFormatStyle<Double>.ChangeStyle {
        FloatingPointFormatStyle.ChangeStyle(currency: currency)
    }
}

public extension FloatingPointFormatStyle {
    struct ChangeStyle: ParseableFormatStyle {
        public var parseStrategy: ChangeStyleParseStrategy
        let currency: Models.Currency
        public typealias FormatInput = Double
        public typealias FormatOutput = String

        init(currency: Models.Currency) {
            parseStrategy = ChangeStyleParseStrategy(currency: currency)
            self.currency = currency
        }

        public func format(_ value: Double) -> String {
            (value * currency.currentValuePerUSD)
                .formatted(baseStyle)
        }

        public struct ChangeStyleParseStrategy: ParseStrategy {
            let currency: Models.Currency

            public func parse(_ value: String) throws -> Double {
                let parsedValue = try baseStyle.parseStrategy.parse(value)
                return parsedValue / currency.currentValuePerUSD
            }

            private var baseStyle: FloatingPointFormatStyle<Double> {
                .number
                    .sign(strategy: .always())
                    .precision(.fractionLength(0 ... 2))
                    .locale(.current)
            }
        }

        private var baseStyle: FloatingPointFormatStyle<Double> {
            .number
                .sign(strategy: .always())
                .precision(.fractionLength(0 ... 2))
                .locale(.current)
        }
    }
}
