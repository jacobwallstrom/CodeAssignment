//
//  CurrencyStyle.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-09-23.
//
import SwiftUI
import Models


extension FormatStyle where Self == FloatingPointFormatStyle<Double>.Currency {
	public static func currencyStyle(_ currency: Models.Currency) -> FloatingPointFormatStyle<Double>.CurrencyStyle {
		return FloatingPointFormatStyle.CurrencyStyle(currency: currency)
	}
}

extension FloatingPointFormatStyle {
	public struct CurrencyStyle: FormatStyle {
		let currency: Models.Currency
		public typealias FormatInput = Double
		public typealias FormatOutput = String

		public func format(_ value: Double) -> String {
			(value * currency.currentValuePerUSD)
				.formatted(baseStyle)
		}

		func parse(_ value: String) throws -> Double {
			let parsedValue = try baseStyle.parseStrategy.parse(value)
			return parsedValue / currency.currentValuePerUSD
		}

		private var baseStyle: FloatingPointFormatStyle<Double>.Currency {
			.currency(code: currency.code)
			.presentation(.narrow)
			.locale(.current)
		}
	}
}
