//
//  EditingPortfolio.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-09-20.
//
import Models
import SwiftUI

struct EditingPortfolioScreen: View {
    // Focus for each text field.
    enum Field: Hashable {
        case name
        case ticker(Int)
        case amount(Int)
        case cost(Int)
        case newRowTicker
        case newRowAmount
        case newRowCost
    }

    @Environment(\.dismiss) private var dismiss
    @Environment(\.currency) private var currency
    @Environment(\.cryptoCurrencyRepository) private var cryptoCurrencyRepository
    @State private var editableHoldings: [EditableHolding]
    @State private var showConfirmationDialog = false
    @FocusState private var focusedField: Field?
    @Bindable private var portfolio: Portfolio
    private let delete: () -> Void

    init(portfolio: Portfolio, delete: @escaping () -> Void, focusedField: Field? = nil) {
        _editableHoldings = State(initialValue: portfolio.holdings
            .map { EditableHolding(holding: $0) })
        self.portfolio = portfolio
        self.delete = delete
        self.focusedField = focusedField
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

                    Text("Edit portfolio")
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .center)
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
                    .submitLabel(.next)
                    .onSubmit { focusedField = .newRowTicker }
                    .font(.title3)
                    .padding(.bottom, 24)

                Text("Holdings")
                    .font(.subheadline)
                    .textCase(.uppercase)
                    .bold()
                    .padding(.bottom, 4)
                Grid(alignment: .leading) {
                    let count: Int = editableHoldings.count
                    ForEach(0 ..< count, id: \.self) { (row: Int) in
                        let holding = $editableHoldings[row]
                        GridRow {
                            CryptoIcon(ticker: holding.ticker.wrappedValue)
                            TextField("Ticker", value: holding.ticker, format: .uppercaseStyle)
                                .focused($focusedField, equals: .ticker(row))
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.alphabet)
                                .submitLabel(.next)
                                .onSubmit { focusedField = .amount(row) }
                                .frame(width: 70)
                            TextField("Amount", value: holding.amount, format: .amountStyle(currency))
                                .focused($focusedField, equals: .amount(row))
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                                .minimumScaleFactor(0.8)
                            TextField("Cost", value: holding.cost, format: .amountStyle(currency))
                                .focused($focusedField, equals: .cost(row))
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                                .minimumScaleFactor(0.8)
                        }
                        Divider()
                    }
                    NewHoldingRow(
                        editableHoldings: $editableHoldings,
                        focusedField: $focusedField
                    ).onAppear {
                        focusedField = .cost(0)
                    }
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
                Button("Done") {
                    withAnimation {
                        focusedField = nil
                    }
                }.frame(maxWidth: .infinity, alignment: .trailing)
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
    EditingPortfolioScreen(portfolio: portfolio, delete: { print("Deleted") })
}

#Preview("Keyboard") {
    @Previewable @State var portfolio = Portfolio.mock
    EditingPortfolioScreen(portfolio: portfolio, delete: { print("Deleted") }, focusedField: .cost(0))
}
