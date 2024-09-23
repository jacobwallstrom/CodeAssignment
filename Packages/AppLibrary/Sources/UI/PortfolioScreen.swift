//
//  HoldingsScreen.swift
//  CodeAssignment
//
//  Created by Jacob Wallström on 2024-09-18.
//

import SwiftUI
import Models

public struct PortfolioScreen: View {
	@Binding var portfolios: [Portfolio]
	@Binding var currency: Currency
	@State private var sheetHeight: CGFloat = .zero
	@State private var selectingPortfolio: Bool
	@State private var selectingCurrency: Bool = false
	@State var selectedPortfolio: Portfolio?
	@State var editingPortfolio: Portfolio? {
		didSet {
			selectingPortfolio = false
		}
	}

	public init(portfolios: Binding<[Portfolio]>, selectingPortfolio: Bool = false, currency: Binding<Currency>) {
		_selectedPortfolio = State(initialValue: portfolios.wrappedValue.first)
		_selectingPortfolio = State(initialValue: selectingPortfolio)
		_portfolios = portfolios
		_currency = currency
	}

	public var body: some View {
		let isEditingBinding = Binding<Bool> {
			editingPortfolio != nil
		} set: {
			assert(!$0, "Binding only used to dismiss sheet")
			editingPortfolio = nil
		}

		VStack {
			if let selectedPortfolio {
				nonempty(portfolio: selectedPortfolio)
			} else {
				empty
			}
		}
		.background(.background)
		.sheet(isPresented: $selectingPortfolio) {
			VStack(alignment: .leading, spacing: 8) {
				Text("Portfolios")
					.textCase(.uppercase)
					.foregroundStyle(.secondary)
					.font(.subheadline)
					.padding(.bottom, 8)
				ForEach(portfolios) { portfolio in
					HStack {
						Button(portfolio.name) {
							selectedPortfolio = portfolio
							selectingPortfolio = false
						}
						Spacer()
						Button(action: {
							editingPortfolio = portfolio
						}) {
							Image(systemName: "pencil.and.list.clipboard")
						}
					}
				}
				Button("Add portfolio") {
					addPortfolio()
				}
				.buttonStyle(.bordered)
				.padding(.top)
				.frame(maxWidth: .infinity)
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding(.horizontal)
			.padding(.vertical, 20)
			.presentationDragIndicator(.visible)
			.modifier(GetHeightModifier(height: $sheetHeight))
			.presentationDetents([.height(sheetHeight)])
		}
		.confirmationDialog("Select currency", isPresented: $selectingCurrency) {
			ForEach(Currency.allCases) { currency in
				Button(currency.code) {
					self.currency = currency
				}
			}
			Button("Cancel", role: .cancel) {}
		}
		.fullScreenCover(isPresented: isEditingBinding) {
			if let editingPortfolio {
				EditingPortfolioScreen(portfolio: editingPortfolio, delete: {
					portfolios.removeAll(where: { $0.id == editingPortfolio.id })
					selectedPortfolio = portfolios.first
				})
			}
		}
	}

	@ViewBuilder var empty: some View {
		Button("Add your first portfolio") {
			addPortfolio()
		}
		.buttonStyle(.borderedProminent)
	}

	@ViewBuilder
	func nonempty(portfolio: Portfolio) -> some View {
		VStack {
			HStack {
				Button(action: {
					selectingPortfolio = true
				}) {
					Text("\(portfolio.name)’s Portfolio")
						.font(.title2)
					Image(systemName: "chevron.up.chevron.down")
						.foregroundStyle(.tint)
				}
				Button(action: {
					selectingCurrency = true
				}) {
					Text(currency.code)
						.font(.title2)
					Image(systemName: "chevron.up.chevron.down")
						.foregroundStyle(.tint)
				}
			}
			.foregroundStyle(.foreground)
			.padding(.bottom, 4)

			let hasValue = portfolio.currentValue != nil
			VStack(spacing: 0) {
				Text((portfolio.currentValue ?? 0).formatted(.currencyStyle(currency)))
					.font(.largeTitle)
				AmountChange(change: portfolio.change, relativeChange: portfolio.relativeChange)
			}
			.opacity(hasValue ? 1: 0)
			.overlay {
				if !hasValue {
					Loading()
						.frame(width: 40)
				}
			}

		}
		.padding(.horizontal)
		Holdings(portfolio: portfolio)
	}

	func addPortfolio() {
		let new = Portfolio(name: "", holdings: [])
		portfolios.append(new)
		selectedPortfolio = new
		editingPortfolio = new
	}
}

struct Holdings: View {
	@Bindable var portfolio: Portfolio

	var body: some View {
		VStack {
			HStack {
				Text("Holdings")
					.textCase(.uppercase)
				Spacer()
				Text("Value")
					.textCase(.uppercase)
			}
			.font(.subheadline)
			.padding(.top, 32)
			.padding(.horizontal)
			.bold()

			ScrollView {
				ForEach($portfolio.holdings) { holding in
					HoldingView(holding: holding)
					if holding.id != portfolio.holdings.last?.id {
						Divider()
					}
				}
				.padding(.horizontal)
			}
		}
	}
}

#Preview("Initial") {
	@Previewable @State var portfolios: [Portfolio] = [.mock]
	@Previewable @State var currency = Currency.usd
	PortfolioScreen(portfolios: $portfolios, currency: $currency)
		.colorScheme(.dark)
}

#Preview("Sheet") {
	@Previewable @State var portfolios: [Portfolio] = [.mock]
	@Previewable @State var currency = Currency.sek
	PortfolioScreen(portfolios: $portfolios, selectingPortfolio: true, currency: $currency)
}

#Preview("No data") {
	@Previewable @State var portfolios: [Portfolio] = {
		let result = Portfolio.mock
		result.holdings.forEach { $0.crypto.lastPrice = nil }
		return [.mock]
	}()
	@Previewable @State var currency = Currency.usd
	PortfolioScreen(portfolios: $portfolios, selectingPortfolio: true, currency: $currency)
}

#Preview("Empty") {
	@Previewable @State var portfolios: [Portfolio] = []
	@Previewable @State var currency = Currency.usd
	PortfolioScreen(portfolios: $portfolios, currency: $currency)
}
