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
    private let maximumNumberOfCharachters = 11

    // MARK: - Public Functions
    func inputFormaterFor(stringValue: String) -> NumberFormatter{
        let numberOfDecimials = Decimal(string: stringValue)
        let formater = NumberFormatter()
        formater.maximumIntegerDigits = 9 - (numberOfDecimials?.significantFractionalDecimalDigits ?? 0)
        formater.maximumFractionDigits = 9 - stringValue.components(separatedBy: ".")[0].count
        formater.minimumFractionDigits = (numberOfDecimials?.significantFractionalDecimalDigits ?? 0)
        formater.maximumIntegerDigits = 9
        formater.minimumIntegerDigits = 1
        formater.groupingSeparator = " "
        formater.roundingMode = .down
        formater.numberStyle = .decimal
        return formater
    }

    func amount(_ amount: Double?) -> String? {
        guard let amount = amount else { return nil}
        return formaterFor(value: amount).string(from: NSDecimalNumber(value: amount))
    }

    func doubleFormat(_ amount: String?) -> Double? {
        guard let amount = formatStringForDouble(amount) else { return nil}
        return Double(amount)
    }

    func getNumberOfItemsIn(value: Double) -> Int {
        let numForm = formater(.decimal)
        numForm.maximumIntegerDigits = 12
        numForm.maximumFractionDigits = 12
        return numForm.string(from: NSDecimalNumber(value: value))?.count ?? 0
    }

    // MARK: - Local functions
    private func formatStringForDouble(_ string: String?) -> String? {
        return string?.replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: " ", with: "")
    }

    private func formaterFor(value: Double) -> NumberFormatter {
        if getNumberOfItemsIn(value: value) > maximumNumberOfCharachters {
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
        formatter.maximumIntegerDigits = 9
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = 9
        formatter.minimumFractionDigits = 0
        formatter.groupingSeparator = " "
        formatter.locale = Locale.current
        formatter.numberStyle = type
        return formatter
    }
}
