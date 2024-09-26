//
//  HoldingsScreen.swift
//  CodeAssignment
//
//  Created by Jacob Wallström on 2024-09-18.
//

import SwiftUI
import Models

public struct PortfolioScreen: View {
	@State var model: PortfolioViewModel
	@State private var sheetHeight: CGFloat = .zero

	public init(model: PortfolioViewModel) {
		self.model = model
	}

	public var body: some View {
		VStack {
			if let selectedPortfolio = model.selectedPortfolio {
				nonempty(portfolio: selectedPortfolio)
			} else {
				empty
			}
		}
		.background(.background)
		.sheet(isPresented: $model.selectingPortfolio) {
			VStack(alignment: .leading, spacing: 8) {
				Text("Portfolios")
					.textCase(.uppercase)
					.foregroundStyle(.secondary)
					.font(.subheadline)
					.padding(.bottom, 8)
				ForEach(model.portfolios) { portfolio in
					HStack {
						Button(portfolio.name) {
							model.selectedPortfolio = portfolio
							model.selectingPortfolio = false
						}
						Spacer()
						Button(action: {
							model.editPortfolioTapped(portfolio)
						}) {
							Image(systemName: "pencil.and.list.clipboard")
						}
					}
				}
				Button("Add portfolio") {
					model.addPortfolioTapped()
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
		.confirmationDialog("Select currency", isPresented: $model.selectingCurrency) {
			ForEach(Currency.allCases) { c in
				Button(c.code) {
					model.selectedCurrency(c)
				}
			}
			Button("Cancel", role: .cancel) {}
		}
		.fullScreenCover(isPresented: model.isEditingBinding) {
			if let editingPortfolio = model.editingPortfolio {
				EditingPortfolioScreen(portfolio: editingPortfolio, delete: {
					model.deletePortfolio()
				})
			}
		}
	}

	@ViewBuilder var empty: some View {
		Button("Add your first portfolio") {
			model.addPortfolioTapped()
		}
		.buttonStyle(.borderedProminent)
	}

	@ViewBuilder
	func nonempty(portfolio: Portfolio) -> some View {
		VStack {
			HStack {
				Button(action: {
					model.selectingPortfolio2()
				}) {
					Text("\(portfolio.name)’s Portfolio")
						.font(.title2)
					Image(systemName: "chevron.up.chevron.down")
						.foregroundStyle(.tint)
				}
				Button(action: {
					model.selectingCurrency2()
				}) {
					Text(model.currency.code)
						.font(.title2)
					Image(systemName: "chevron.up.chevron.down")
						.foregroundStyle(.tint)
				}
			}
			.foregroundStyle(.foreground)
			.padding(.bottom, 4)

			let hasValue = portfolio.currentValue != nil
			VStack(spacing: 0) {
				Text((portfolio.currentValue ?? 0).formatted(.currencyStyle(model.currency)))
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
}

struct Holdings: View {
	@Bindable var portfolio: Portfolio

	var body: some View {
		VStack {
			HStack {
				Text("Holdings")
					.textCase(.uppercase)
					.frame(maxWidth: .infinity, alignment: .leading)
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

@Observable @MainActor
public class PortfolioViewModel {
	public var currency: Currency
	var selectingPortfolio = false
	var selectedPortfolio: Portfolio?
	var destination: Destination?
	var portfolios: [Portfolio]
	var selectingCurrency: Bool = false
	var editingPortfolio: Portfolio? {
		didSet {
			selectingPortfolio = false
		}
	}

	enum Destination {
		case selecting
	}

	public init(portfolios: [Portfolio], selectingPortfolio: Bool = false, currency: Currency) {
		_portfolios = portfolios
		_currency = currency
		self.selectingPortfolio = selectingPortfolio
		self.selectedPortfolio = portfolios.first

	}

	var isEditingBinding: Binding<Bool> {
		Binding { [weak self] in
			self?.editingPortfolio != nil
		} set: { [weak self] newValue, _ in
			assert(!newValue, "Binding only used to dismiss sheet")
			self?.editingPortfolio = nil
		}
	}

	func selectingPortfolio2() {
		selectingPortfolio = true
	}

	func addPortfolioTapped() {
		let new = Portfolio(name: "", holdings: [])
		portfolios.append(new)
		selectedPortfolio = new
		editingPortfolio = new
	}

	func editPortfolioTapped(_ portfolio: Portfolio) {
		editingPortfolio = portfolio
	}

	func selectingCurrency2() {
		selectingCurrency = true
	}

	func selectedCurrency(_ currency: Currency) {
		self.currency = currency
	}

	func deletePortfolio() {
		guard let editingPortfolio else { fatalError() }
		portfolios.removeAll(where: { $0.id == editingPortfolio.id })
		selectedPortfolio = self.portfolios.first
	}
}

#Preview("Initial") {
	@Previewable @State var model = PortfolioViewModel(portfolios: [.mock], currency: .usd)
	PortfolioScreen(model: model)
		.colorScheme(.dark)
}

#Preview("No data") {
	@Previewable @State var model = {
		let portfolio = Portfolio.mock
		portfolio.holdings.forEach { $0.crypto.lastPrice = nil }
		return PortfolioViewModel(portfolios: [portfolio], selectingPortfolio: true, currency: .usd)
	}()
	PortfolioScreen(model: model)
}

#Preview("Empty") {
	@Previewable @State var model = PortfolioViewModel(portfolios: [], currency: .usd)
	PortfolioScreen(model: model)
}

