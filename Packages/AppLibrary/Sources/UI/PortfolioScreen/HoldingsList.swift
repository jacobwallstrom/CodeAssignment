//
//  HoldingsList.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-09-27.
//
import SwiftUI
import Models

struct HoldingsList: View {
	var holdings: [Holding]

	var body: some View {
		VStack {
			HStack {
				Text("Holdings")
					.textCase(.uppercase)
					.frame(maxWidth: .infinity, alignment: .leading)
				Text("Value")
					.textCase(.uppercase)
			}
			.font(.subheadline)
			.padding(.top, 32)
			.padding(.horizontal)
			.bold()

			ScrollView {
				ForEach(holdings) { holding in
					HoldingView(holding: holding)
					if holding.id != holdings.last?.id {
						Divider()
					}
				}
				.padding(.horizontal)
			}
		}
	}
}

