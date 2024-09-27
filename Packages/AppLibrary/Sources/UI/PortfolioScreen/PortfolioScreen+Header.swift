//
//  PortfolioScreen+Header.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-09-27.
//

import Models
import SwiftUI

extension PortfolioScreen {
    struct Header: View {
        let selectedPortfolio: Portfolio
        let currency: Currency
        var selectPortfolioTapped: () -> Void
        var selectCurrencyTapped: () -> Void

        var body: some View {
            VStack {
                HStack {
                    Button {
                        selectPortfolioTapped()
                    } label: {
                        let name = selectedPortfolio.name
                        Text("\(name)’s Portfolio")
                            .font(.title2)
                        Image(systemName: "chevron.up.chevron.down")
                            .foregroundStyle(.tint)
                    }
                    Button {
                        selectCurrencyTapped()
                    } label: {
                        Text(currency.code)
                            .font(.title2)
                        Image(systemName: "chevron.up.chevron.down")
                            .foregroundStyle(.tint)
                    }
                }
                .foregroundStyle(.foreground)
                .padding(.bottom, 4)

                let hasValue = selectedPortfolio.currentValue != nil
                VStack(spacing: 0) {
                    Text((selectedPortfolio.currentValue ?? 0).formatted(.currencyStyle(currency)))
                        .font(.largeTitle)
                    AmountChange(change: selectedPortfolio.change, relativeChange: selectedPortfolio.relativeChange)
                }
                .opacity(hasValue ? 1 : 0)
                .overlay {
                    if !hasValue {
                        Loading()
                            .frame(width: 40)
                    }
                }
            }
        }
    }
}
