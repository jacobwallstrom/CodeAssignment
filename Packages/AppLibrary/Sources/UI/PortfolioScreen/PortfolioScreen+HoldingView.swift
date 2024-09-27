//
//  File.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-09-19.
//
import Models
import SwiftUI

extension PortfolioScreen {
    struct HoldingView: View {
        var holding: Holding
        @Environment(\.currency) var currency

        public var body: some View {
            HStack {
                CryptoIcon(ticker: holding.crypto.baseAsset)
                VStack(alignment: .leading) {
                    Text(holding.crypto.baseAsset)
                        .textCase(.uppercase)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                    HStack(spacing: 2) {
                        let atPrice = if let lastPrice = holding.crypto.lastPrice {
                            " at \(lastPrice.formatted(.currencyStyle(currency)))"
                        } else {
                            ""
                        }
                        Text(
                            "\(holding.amount.formatted(.amountStyle(currency))) \(atPrice)"
                        )
                        .font(.footnote)
                    }
                }
                VStack(alignment: .trailing) {
                    if let currentValue = holding.currentValue, let relativeChange = holding.relativeChange {
                        Text(currentValue.formatted(.currencyStyle(currency)))
                        AmountChange(change: holding.change, relativeChange: relativeChange)
                            .font(.footnote)
                    } else {
                        Loading()
                            .frame(width: 25)
                    }
                }
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    @Previewable @State var mock1 = Holding.mock1
    @Previewable @State var mock2 = Holding.mock2
    @Previewable @State var mock3 = Holding(crypto: .noPrice, amount: 1, cost: 3000)

    VStack {
        PortfolioScreen.HoldingView(holding: mock1)
        PortfolioScreen.HoldingView(holding: mock2)
    }
    .padding()
    .background(.background)
    .colorScheme(.dark)

    VStack {
        PortfolioScreen.HoldingView(holding: mock1)
        PortfolioScreen.HoldingView(holding: mock2)
        PortfolioScreen.HoldingView(holding: mock3)
    }
    .padding()
    .background(.background)
    .colorScheme(.light)
}
