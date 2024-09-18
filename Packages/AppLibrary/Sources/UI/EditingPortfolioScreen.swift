//
//  EditingPortfolio.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-09-20.
//
import SwiftUI
import Models

struct EditingPortfolioScreen: View {
	enum Field {
		case ticker
		case amount
		case cost
		case name
	}

	@Environment(\.dismiss) private var dismiss
	@Environment(\.currency) private var currency
	@Environment(\.cryptoCurrencyRepository) private var cryptoCurrencyRepository
	@State private var editableHoldings: [EditableHolding]
	@State private var showConfirmationDialog = false
	@FocusState private var focusedField: Field?
	@Bindable private var portfolio: Portfolio
	private let delete: () -> Void

	init(portfolio: Portfolio, delete: @escaping () -> Void) {
		_editableHoldings = State(initialValue: portfolio.holdings
			.map { EditableHolding(holding: $0) })
		self.portfolio = portfolio
		self.delete = delete
	}

	func save() {
		portfolio.holdings = editableHoldings
			.filter { $0.amount > 0 }
			.compactMap { $0.holding(cryptoCurrencyRepository) }
	}

	var body: some View {
		ScrollView {
			VStack(alignment: .leading) {
				HStack(alignment: .center) {
					Button(action: {
						showConfirmationDialog = true
					}) {
						Image(systemName: "trash")
					}
					.foregroundStyle(.red)
					
					Spacer()
					Text("Edit portfolio")
						.font(.title2)
					Spacer()
					
					Button(action: {
						dismiss()
					}) {
						Image(systemName: "xmark")
					}
				}
				.padding(.bottom, 24)
				
				Text("Portfolio name")
					.textCase(.uppercase)
					.font(.subheadline)
					.bold()
					.frame(alignment: .leading)
				TextField("", text: $portfolio.name)
					.textFieldStyle(.roundedBorder)
					.focused($focusedField, equals: .name)
					.font(.title3)
					.padding(.bottom, 24)

				Text("Holdings")
					.font(.subheadline)
					.textCase(.uppercase)
					.bold()
					.padding(.bottom, 4)
				Grid(alignment: .leading) {
					ForEach($editableHoldings) { (holding: Binding<EditableHolding>) in
						GridRow {
							CryptoIcon(ticker: holding.ticker.wrappedValue)
							TextField("Ticker", value: holding.ticker, format: .uppercaseStyle)
								.focused($focusedField, equals: .ticker)
								.textFieldStyle(.roundedBorder)
								.keyboardType(.alphabet)
								.submitLabel(.next)
								.onSubmit { focusedField = .amount }
								.frame(width: 70)
							TextField("Amount", value: holding.amount, format: .amountStyle(currency))
								.focused($focusedField, equals: .amount)
								.textFieldStyle(.roundedBorder)
								.keyboardType(.decimalPad)
								.minimumScaleFactor(0.8)
							TextField("Cost", value: holding.cost, format: .amountStyle(currency))
								.focused($focusedField, equals: .cost)
								.textFieldStyle(.roundedBorder)
								.keyboardType(.decimalPad)
								.minimumScaleFactor(0.8)
						}
						Divider()
					}
					NewHoldingRow(
						editableHoldings: $editableHoldings,
						focusedField: $focusedField
					)
				}
				.fixedSize(horizontal: false, vertical: true)
			}
			.padding()
			.autocorrectionDisabled()
			.confirmationDialog("Delete item", isPresented: $showConfirmationDialog) {
				Button("Delete this portfolio", role: .destructive) {
					delete()
					dismiss()
				}
				Button("Cancel", role: .cancel) {}
			}
		}
		.toolbar {
			ToolbarItemGroup(placement: .keyboard) {
				Spacer()
				Button("Done") {
					withAnimation {
						focusedField = nil
					}
				}
			}
		}
		if focusedField == nil {
			Button("Update") {
				save()
				dismiss()
			}
			.buttonStyle(.borderedProminent)
			.frame(maxWidth: .infinity)
		}
	}
}

#Preview {
	@Previewable @State var portfolio = Portfolio.mock
	EditingPortfolioScreen(portfolio: portfolio, delete: { print("Deleted" )})
}

