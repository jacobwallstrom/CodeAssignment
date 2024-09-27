//
//  HoldingsScreen.swift
//  CodeAssignment
//
//  Created by Jacob Wallström on 2024-09-18.
//

import SwiftUI
import Models
import SwiftUINavigation

public struct PortfolioScreen: View {
	@State var model: ViewModel

	public init(model: ViewModel) {
		self.model = model
	}

	public var body: some View {
		VStack {
			if let selectedPortfolio = model.selectedPortfolio {
				VStack {
					HStack {
						Button(action: {
							model.selectingPortfolio()
						}) {
							let name = selectedPortfolio.name
							Text("\(name)’s Portfolio")
								.font(.title2)
							Image(systemName: "chevron.up.chevron.down")
								.foregroundStyle(.tint)
						}
						Button(action: {
							model.selectingCurrency()
						}) {
							Text(model.currency.code)
								.font(.title2)
							Image(systemName: "chevron.up.chevron.down")
								.foregroundStyle(.tint)
						}
					}
					.foregroundStyle(.foreground)
					.padding(.bottom, 4)

					let hasValue = selectedPortfolio.currentValue != nil
					VStack(spacing: 0) {
						Text((selectedPortfolio.currentValue ?? 0).formatted(.currencyStyle(model.currency)))
							.font(.largeTitle)
						AmountChange(change: selectedPortfolio.change, relativeChange: selectedPortfolio.relativeChange)
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
				Holdings(portfolio: selectedPortfolio)
			} else {
				Button("Add your first portfolio") {
					model.addPortfolioTapped()
				}
				.buttonStyle(.borderedProminent)
			}
		}
		.sheet(isPresented: Binding($model.destination.selectingPortfolio)) {
			SelectPortfolioSheet(model: model)
		}
		.confirmationDialog("Select currency", isPresented: Binding($model.destination.selectingCurrency)) {
			ForEach(Currency.allCases) { c in
				Button(c.code) {
					model.selectedCurrency(c)
				}
			}
			Button("Cancel", role: .cancel) {}
		}
		.fullScreenCover(item: $model.destination.editingPortfolio) { item in
			EditingPortfolioScreen(portfolio: item, delete: {
				model.deletePortfolio(item)
			})
		}
		.environment(\.currency, model.currency)
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

#Preview("Initial") {
	@Previewable @State var model = PortfolioScreen.ViewModel(portfolios: [.mock], currency: .usd)
	PortfolioScreen(model: model)
		.colorScheme(.dark)
}

#Preview("No data") {
	@Previewable @State var model = {
		let portfolio = Portfolio.mock
		portfolio.holdings.forEach { $0.crypto.lastPrice = nil }
		return PortfolioScreen.ViewModel(portfolios: [portfolio], currency: .usd, destination: .selectingPortfolio)
	}()
	PortfolioScreen(model: model)
}

#Preview("Empty") {
	@Previewable @State var model = PortfolioScreen.ViewModel(portfolios: [], currency: .usd)
	PortfolioScreen(model: model)
}

