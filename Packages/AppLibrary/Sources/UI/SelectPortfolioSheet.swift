//
//  SelectPortfolioSheet.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-09-27.
//
import SwiftUI
import Models
import SwiftUINavigation

struct SelectPortfolioSheet: View {
	@State var model: PortfolioScreen.ViewModel
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
}
