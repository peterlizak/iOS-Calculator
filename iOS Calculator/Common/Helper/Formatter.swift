//
//  Formatter.swift
//  iOS Calculator
//
//  Created by Peter Lizak on 25/03/2020.
//  Copyright © 2020 Peter Lizak. All rights reserved.
//

import Foundation

class Formatter {

    // MARK: - Public Functions
    func userInputFormaterFor(stringValue: String) -> NumberFormatter {
        let numberOfDecimials = Decimal(string: stringValue)
        let formater = NumberFormatter()
        formater.maximumIntegerDigits = 9 - (numberOfDecimials?.significantFractionalDecimalDigits ?? 0)
        formater.maximumFractionDigits = 9 - stringValue.components(separatedBy: ".")[0].count
        formater.minimumFractionDigits = (numberOfDecimials?.significantFractionalDecimalDigits ?? 0)
        formater.minimumIntegerDigits = 1
        formater.maximumIntegerDigits = 9
        formater.groupingSeparator = " "
        formater.locale = Locale.current
        formater.numberStyle = .decimal
        formater.roundingMode = .down
        return formater
    }

    // MARK: - Value parsing
    func doubleToString(_ value: Double?) -> String? {
        guard let value = value else { return nil}
        return formaterFor(value: value).string(from: NSDecimalNumber(value: value))
    }

    func stringToDouble(_ value: String?) -> Double? {
        guard let value = value else { return nil}
        return Double(value)
    }

    // MARK: - Local functions
    private func getNumberOfItemsIn(value: Double) -> Int {
        let numForm = resultFormater(.decimal)
        numForm.maximumIntegerDigits = 140
        numForm.maximumFractionDigits = 140
        return numForm.string(from: NSNumber(value: Double(value)))?.count ?? 0
    }

    private func formaterFor(value: Double) -> NumberFormatter {
        if getNumberOfItemsIn(value: value) > 11 {
            return resultFormater(.scientific)
        }
        return resultFormater(.decimal)
    }

    private func resultFormater(_ type: NumberFormatter.Style) -> NumberFormatter {
        let formatter = NumberFormatter()
        if type == .scientific {
            formatter.maximumIntegerDigits = 1
            formatter.maximumFractionDigits = 5
        } else {
            formatter.maximumIntegerDigits = 9
            formatter.maximumFractionDigits = 9
        }
        formatter.minimumFractionDigits = 0
        formatter.minimumIntegerDigits = 1
        formatter.groupingSeparator = " "
        formatter.locale = Locale.current
        formatter.numberStyle = type
        return formatter
    }
}
