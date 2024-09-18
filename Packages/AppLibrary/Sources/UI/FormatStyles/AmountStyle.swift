//
//  AmountStyle.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-09-23.
//
import SwiftUI
import Models

extension FormatStyle where Self == FloatingPointFormatStyle<Double> {
	public static func amountStyle(_ currency: Models.Currency) -> FloatingPointFormatStyle<Double>.AmountStyle {
		return FloatingPointFormatStyle.AmountStyle(currency: currency)
	}
}

extension FloatingPointFormatStyle {
	public struct AmountStyle: ParseableFormatStyle {
		public var parseStrategy: AmountStyleParseStrategy
		let currency: Models.Currency
		public typealias FormatInput = Double
		public typealias FormatOutput = String

		init(currency: Models.Currency) {
			self.parseStrategy = AmountStyleParseStrategy(currency: currency)
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

