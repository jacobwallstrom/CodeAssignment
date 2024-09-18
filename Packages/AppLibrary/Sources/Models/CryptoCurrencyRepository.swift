//
//  CryptoCurrencyRepository.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-09-21.
//
import SwiftUI

@MainActor @Observable
public class CryptoCurrencyRepository {
	private var cryptoCurrencies: [String: CryptoCurrency] = [:]

	nonisolated public init() {	}

	public func getCurrency(_ baseAsset: String) -> CryptoCurrency {
		if let result = cryptoCurrencies[baseAsset] {
			return result
		}
		let baseAsset = baseAsset.uppercased()
		let result = CryptoCurrency(baseAsset: baseAsset)
		cryptoCurrencies[baseAsset] = result
		return result
	}

	public func update(baseAsset: String, lastPrice: Double) {
		let baseAsset = baseAsset.uppercased()
		guard getCurrency(baseAsset).lastPrice != lastPrice else { return }
		getCurrency(baseAsset).lastPrice = lastPrice
	}
}

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
