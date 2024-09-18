//
//  UppercaseFormatStyle.swift
//  AppLibrary
//
//  Created by Jacob Wallström on 2024-09-23.
//
import SwiftUI

struct UppercaseFormatStyle: ParseableFormatStyle {
	var parseStrategy = UppercaseParseStrategy()
	typealias FormatInput = String
	typealias FormatOutput = String

	func format(_ value: String) -> String {
		value.uppercased()
	}

	struct UppercaseParseStrategy: ParseStrategy {
		func parse(_ value: String) throws -> String {
			value.uppercased()
		}
	}
}


extension FormatStyle where Self == UppercaseFormatStyle {
	static var uppercaseStyle: UppercaseFormatStyle {
		.init()
	}
}
