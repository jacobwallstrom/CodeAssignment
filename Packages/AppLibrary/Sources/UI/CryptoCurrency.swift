//
//  File.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-09-19.
//
import SwiftUI
import Models

struct CryptoIcon: View {
	enum AllIcons: String, CaseIterable {
		case btc
		case eth
	}

	let ticker: String
	let size: CGFloat = 32

	var body: some View {
		let ticker = ticker.lowercased()
		if AllIcons.allCases.map(\.rawValue).contains(ticker) {
			Image(ticker, bundle: .module)
				.resizable()
				.scaledToFit()
				.frame(width: 32)
		} else {
			Image(systemName: "questionmark.circle")
				.frame(width: 32)
		}
	}
}

