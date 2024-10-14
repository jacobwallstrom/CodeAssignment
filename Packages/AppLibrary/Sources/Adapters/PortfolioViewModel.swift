//
//  ViewModel.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-09-27.
//
import CasePaths
import Models
import Observation

@Observable @MainActor
public class PortfolioViewModel {
    @CasePathable
    public enum Destination {
        case selectingCurrency
        case selectingPortfolio
        case editingPortfolio(Portfolio)
    }

    public var currency: Currency
    public var selectedPortfolio: Portfolio?
    public var destination: Destination?
    public var portfolios: [Portfolio]

    public init(portfolios: [Portfolio], currency: Currency, destination: Destination? = nil) {
        self.portfolios = portfolios
        self.currency = currency
        self.destination = destination
        selectedPortfolio = portfolios.first
    }

    public func selectPortfolioTapped() {
        destination = .selectingPortfolio
    }

    public func selectedPortfolio(_ portfolio: Portfolio) {
        selectedPortfolio = portfolio
        destination = nil
    }

    public func addPortfolioTapped() {
        let new = Portfolio(name: "", holdings: [])
        portfolios.append(new)
        destination = .editingPortfolio(new)
    }

    public func editPortfolioTapped(_ portfolio: Portfolio) {
        destination = .editingPortfolio(portfolio)
    }

    public func selectCurrencyTapped() {
        destination = .selectingCurrency
    }

    public func selectedCurrency(_ currency: Currency) {
        self.currency = currency
    }

    public func deletePortfolio(_ portfolio: Portfolio) {
        portfolios.removeAll { $0.id == portfolio.id }
        selectedPortfolio = portfolios.first
    }
}
