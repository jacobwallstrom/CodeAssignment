//
//  CodeAssignmentApp.swift
//  CodeAssignment
//
//  Created by Jacob Wallström on 2024-09-18.
//

import Adapters
import Infrastructure
import Models
import SwiftUI
import UseCases

@main
struct CodeAssignmentApp: App {
    let dependencies = Dependencies.shared
    @State private var model = PortfolioViewModel(
        portfolios: [
            Dependencies.shared.samplePortfolio,
            Dependencies.shared.samplePortfolio2,
        ],
        currency: .usd
    )

    var body: some Scene {
        WindowGroup {
            PortfolioScreen(model: model)
                .task {
                    await dependencies.tracker.startUpdating()
                }
                .environment(dependencies.repository)
                .tint(.orange)
        }
    }
}

