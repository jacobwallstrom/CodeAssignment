//
//  ViewModel.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-09-27.
//
import SwiftUI
import SwiftUINavigation
import Models

extension PortfolioScreen {
	@Observable @MainActor
	public class ViewModel {
		@CasePathable
		public enum Destination {
			case selectingCurrency
			case selectingPortfolio
			case editingPortfolio(Portfolio)
		}

		var currency: Currency
		var selectedPortfolio: Portfolio?
		var destination: Destination?
		var portfolios: [Portfolio]

		public init(portfolios: [Portfolio], currency: Currency, destination: Destination? = nil) {
			self.portfolios = portfolios
			self.currency = currency
			self.destination = destination
			self.selectedPortfolio = portfolios.first

		}

		func selectPortfolioTapped() {
			destination = .selectingPortfolio
		}

		func selectedPortfolio(_ portfolio: Portfolio) {
			selectedPortfolio = portfolio
			destination = nil
		}

		func addPortfolioTapped() {
			let new = Portfolio(name: "", holdings: [])
			portfolios.append(new)
			destination = .editingPortfolio(new)
		}

		func editPortfolioTapped(_ portfolio: Portfolio) {
			destination = .editingPortfolio(portfolio)
		}

		func selectCurrencyTapped() {
			destination = .selectingCurrency
		}

		func selectedCurrency(_ currency: Currency) {
			self.currency = currency
		}

		func deletePortfolio(_ portfolio: Portfolio) {
			portfolios.removeAll(where: { $0.id == portfolio.id })
			selectedPortfolio = self.portfolios.first
		}
	}
}

