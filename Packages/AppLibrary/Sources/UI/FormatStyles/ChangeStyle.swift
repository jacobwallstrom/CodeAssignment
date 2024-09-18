//
//  ChangeStyle.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-09-23.
//
import SwiftUI
import Models

extension FormatStyle where Self == FloatingPointFormatStyle<Double> {
	public static func changeStyle(_ currency: Models.Currency) -> FloatingPointFormatStyle<Double>.ChangeStyle {
		return FloatingPointFormatStyle.ChangeStyle(currency: currency)
	}
}

extension FloatingPointFormatStyle {
	public struct ChangeStyle: ParseableFormatStyle {
		public var parseStrategy: ChangeStyleParseStrategy
		let currency: Models.Currency
		public typealias FormatInput = Double
		public typealias FormatOutput = String

		init(currency: Models.Currency) {
			self.parseStrategy = ChangeStyleParseStrategy(currency: currency)
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
				.precision(.fractionLength(0...2))
				.locale(.current)
			}
		}

		private var baseStyle: FloatingPointFormatStyle<Double> {
			.number
			.sign(strategy: .always())
			.precision(.fractionLength(0...2))
			.locale(.current)
		}
	}
}
