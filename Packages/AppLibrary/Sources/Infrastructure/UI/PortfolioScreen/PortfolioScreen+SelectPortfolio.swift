//
//  SelectPortfolio.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-09-27.
//
import Adapters
import Models
import SwiftUI
import SwiftUINavigation

extension PortfolioScreen {
    struct SelectPortfolio: View {
        @State var model: PortfolioViewModel
        @State private var sheetHeight: CGFloat = .zero

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text("Portfolios")
                    .textCase(.uppercase)
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                    .padding(.bottom, 8)
                ForEach(model.portfolios) { portfolio in
                    HStack {
                        Button(portfolio.name) {
                            model.selectedPortfolio(portfolio)
                        }
                        Spacer()
                        Button {
                            model.editPortfolioTapped(portfolio)
                        } label: {
                            Image(systemName: "pencil.and.list.clipboard")
                                .accessibilityLabel("Edit")
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
    }
}
