//
//  PortfolioScreen.swift
//  CodeAssignment
//
//  Created by Jacob Wallström on 2024-09-18.
//

import Models
import SwiftUI
import SwiftUINavigation

public struct PortfolioScreen: View {
    @State var model: ViewModel

    public init(model: ViewModel) {
        self.model = model
    }

    public var body: some View {
        VStack {
            if let selectedPortfolio = model.selectedPortfolio {
                Header(
                    selectedPortfolio: selectedPortfolio,
                    currency: model.currency,
                    selectPortfolioTapped: {
                        model.selectPortfolioTapped()
                    },
                    selectCurrencyTapped: {
                        model.selectCurrencyTapped()
                    }
                )
                .padding(.horizontal)
                HoldingsList(holdings: selectedPortfolio.holdings)
            } else {
                Button("Add your first portfolio") {
                    model.addPortfolioTapped()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .sheet(isPresented: Binding($model.destination.selectingPortfolio)) {
            SelectPortfolio(model: model)
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
