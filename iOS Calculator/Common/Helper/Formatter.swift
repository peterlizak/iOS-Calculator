//
//  Formatter.swift
//  iOS Calculator
//
//  Created by Peter Lizak on 25/03/2020.
//  Copyright © 2020 Peter Lizak. All rights reserved.
//

import Foundation

class Formatter {

    // MARK: - Properties
    private lazy var maximumNumberOfDigits = maximumNumberOfCharachters - (maximumNumberOfCharachters / 4)
    private let maximumNumberOfCharachters = 12

    // MARK: - Public Functions
    func amount(_ amount: Double?) -> String? {
        guard let amount = amount else { return nil}
        return formaterFor(value: amount).string(from: NSNumber(value: amount))
    }

    func stringFormat(_ amount: String?) -> String? {
        guard let amount = amount  else { return nil}

        let formater = formaterFor(string: amount)
        if let stringForDouble = formatStringForDouble(amount), let value = Double(stringForDouble){
            return formater.string(from: NSNumber(value: value))
        }
        return nil
    }

    func doubleFormat(_ amount: String?) -> Double? {
        guard let amount = formatStringForDouble(amount) else { return nil}
        return Double(amount)
    }

    // MARK: - Local functions
    private func formatStringForDouble(_ string: String?) -> String? {
        return string?.replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: " ", with: "")
    }

    private func getNumberOfItemsIn(value: Double) -> Int {
        return formater(.decimal).string(from: NSNumber(value: value))?.count ?? 0
    }

    private func formaterFor(value: Double) -> NumberFormatter {
        if getNumberOfItemsIn(value: value) > maximumNumberOfDigits {
            return formater(.scientific)
        }
        return formater(.decimal)
    }

    private func formaterFor(string: String) -> NumberFormatter {
        if string.count > maximumNumberOfCharachters {
            return formater(.scientific)
        }
        return formater(.decimal)
    }

    private func formater(_ type: NumberFormatter.Style) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.maximumIntegerDigits = maximumNumberOfDigits
        formatter.maximumFractionDigits = 8
        formatter.minimumFractionDigits = 0
        formatter.minimumIntegerDigits = 1
        formatter.groupingSeparator = " "
        formatter.locale = Locale.current
        formatter.numberStyle = type
        return formatter
    }
}
