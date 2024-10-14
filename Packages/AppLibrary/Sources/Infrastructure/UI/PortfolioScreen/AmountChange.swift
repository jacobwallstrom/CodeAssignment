//
//  AmountChange.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-09-19.
//
import Models
import SwiftUI

struct AmountChange: View {
    @Environment(\.currency) var currency
    let change: Double?
    let relativeChange: Double?

    var body: some View {
        HStack {
            Text((change ?? 0).formatted(.changeStyle(currency)))
            Text((relativeChange ?? 0).formatted(.percentStyle))
        }
        .foregroundStyle((change ?? 0) >= 0 ? .green : .red)
    }
}
