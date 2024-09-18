//
//  NewHoldingRow.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-09-22.
//
import SwiftUI
import Models

struct NewHoldingRow: View {
	@Environment(\.cryptoCurrencyRepository) private var cryptoCurrencyRepository
	@Environment(\.currency) var currency
	@Binding var editableHoldings: [EditableHolding]
	var focusedField: FocusState<EditingPortfolioScreen.Field?>.Binding
	@State private var ticker: String = ""
	@State private var amount: Double?
	@State private var cost: Double?

	var body: some View {
		GridRow {
			CryptoIcon(ticker: ticker)
				.opacity(ticker.isEmpty ? 0 : 1)
			TextField("Ticker", value: $ticker, format: .uppercaseStyle)
				.focused(focusedField, equals: .ticker)
				.textFieldStyle(.roundedBorder)
				.keyboardType(.alphabet)
				.submitLabel(.next)
				.onSubmit { focusedField.wrappedValue = .amount }
				.frame(width: 70)
			TextField("Amount", value: $amount, format: .amountStyle(currency))
				.focused(focusedField, equals: .amount)
				.textFieldStyle(.roundedBorder)
				.keyboardType(.decimalPad)
				.minimumScaleFactor(0.8)
			TextField("Cost", value: $cost, format: .amountStyle(currency))
				.focused(focusedField, equals: .cost)
				.textFieldStyle(.roundedBorder)
				.keyboardType(.decimalPad)
				.minimumScaleFactor(0.8)
		}
		.onChange(of: focusedField.wrappedValue != nil) { wasVisible, isVisible in
			if wasVisible, !isVisible {
				validateAndAdd()
			}
		}
	}

	private func validateAndAdd() {
		guard let amount, let cost, !ticker.isEmpty else { return }
		editableHoldings.append(.init(ticker: ticker, amount: amount, cost: cost))
		self.ticker = ""
		self.amount = nil
		self.cost = nil
	}
}

@MainActor
struct EditableHolding: Identifiable {
	let id = UUID()
	var ticker: String
	var amount: Double
	var cost: Double

	init(ticker: String, amount: Double, cost: Double) {
		self.ticker = ticker
		self.amount = amount
		self.cost = cost
	}

	init(holding: Holding) {
		ticker = holding.crypto.baseAsset
		amount = holding.amount
		cost = holding.cost
	}

	func holding(_ cryptoCurrencyRepository: CryptoCurrencyRepository) -> Holding? {
		.init(
			crypto: cryptoCurrencyRepository.getCurrency(ticker),
			amount: amount,
			cost: cost
		)
	}
}
