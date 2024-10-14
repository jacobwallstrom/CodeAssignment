//
//  Loading.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-09-22.
//
import SwiftUI

struct Loading: View {
    var body: some View {
        Image(systemName: "ellipsis")
            .resizable()
            .scaledToFit()
            .symbolEffect(.breathe)
            .accessibilityLabel("Loading")
    }
}
