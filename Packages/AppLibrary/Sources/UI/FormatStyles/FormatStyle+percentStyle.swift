//
//  FormatStyle+percentStyle.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-09-23.
//

import Models
import SwiftUI

extension FormatStyle where Self == FloatingPointFormatStyle<Double>.Percent {
    static var percentStyle: FloatingPointFormatStyle<Double>.Percent {
        .percent
            .precision(.fractionLength(0 ... 2))
            .locale(.current)
    }
}
