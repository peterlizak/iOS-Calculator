//
//  CalculatorLogic.swift
//  iOS Calculator
//
//  Created by Peter Lizak on 24/03/2020.
//  Copyright © 2020 Peter Lizak. All rights reserved.
//

import Foundation
import UIKit

class CalculatorLogic {

    private var numberFormater = Formatter()
    private var waitingActionOperationTag: Int?
    private var pendingOperationTag: Int?
    private var currentInputValue: Double?
    private var pendingValue: Double?

    func handleInput(tag: Int, input: UITextField) {
        if (0...9).contains(tag) {
            updateNumber(tag: String(tag), input: input)
        } else if tag == 10 {
            addComa(input: input)
        } else if (11...14).contains(tag) {
            updateOperation(tag: tag, input: input)
        } else if tag == 15 {
            addPercentage(input: input)
        } else if tag == 16 {
            addOposite(input: input)
        } else if tag == 17 {
            resetInput(input: input)
        } else if tag == 18 {
            calculateResult(input: input)
        }
    }

    private func updateNumber(tag: String, input: UITextField) {
        if waitingActionOperationTag != nil {
            pendingOperationTag = waitingActionOperationTag
            waitingActionOperationTag = nil
            input.text = ""
        }

        if let text = input.text, text != "0" {
            if let repleacmentText = numberFormater.stringFormat(text + tag), repleacmentText.count < 12 {
                input.text = repleacmentText
                currentInputValue = numberFormater.doubleFormat(input.text)
            }
        }
    }

    private func addComa(input: UITextField) {
        if waitingActionOperationTag != nil {
            pendingOperationTag = waitingActionOperationTag
            waitingActionOperationTag = nil
            input.text = "0,"
            return
        }

        if input.text?.contains(",") ?? true { return }

        if let text = input.text, text.count != 0 {
            input.text = text + ","
        } else {
            input.text = "0,"
        }
    }

    private func updateOperation(tag: Int, input: UITextField) {
        if pendingOperationTag == nil {
            waitingActionOperationTag = tag
            pendingValue = numberFormater.doubleFormat(input.text)
            return
        }

        if let pendingTag = pendingOperationTag, let pendingValue = pendingValue, let currentValue = numberFormater.doubleFormat(input.text) {
            input.text = executeOperation(tag: pendingTag, pendingValue: pendingValue, currentValue: currentValue)
            self.pendingValue = numberFormater.doubleFormat(input.text)
            waitingActionOperationTag = tag
            pendingOperationTag = nil
        }
    }

    private func addPercentage(input: UITextField) {
        if let inputValue = numberFormater.doubleFormat(input.text) {
            input.text = numberFormater.amount(inputValue / 100.0)
        }
    }

    private func addOposite(input: UITextField) {
        if let inputValue = numberFormater.doubleFormat(input.text) {
            input.text = numberFormater.amount(inputValue * -1.0)
        }
    }

    private func resetInput(input: UITextField) {
        waitingActionOperationTag = nil
        pendingOperationTag = nil
        pendingValue = nil
        input.text = ""
    }

    private func calculateResult(input: UITextField) {
        // INSTANCE INPUT CASE: 1 + =
        if let tag = waitingActionOperationTag, let value = currentInputValue, let pendingValue = pendingValue {
            input.text = executeOperation(tag: tag, pendingValue: value, currentValue: pendingValue)
            currentInputValue = numberFormater.doubleFormat(input.text)
        } else if let tag = waitingActionOperationTag, let value = currentInputValue {
            input.text = executeOperation(tag: tag, pendingValue: value, currentValue: value)
            currentInputValue = numberFormater.doubleFormat(input.text)
            pendingValue = value
        }

        if let tag = pendingOperationTag, let pendingValue = pendingValue, let inputValue = currentInputValue {
            input.text = executeOperation(tag: tag, pendingValue: pendingValue, currentValue: inputValue)
            waitingActionOperationTag = pendingOperationTag
            pendingOperationTag = nil
            currentInputValue = numberFormater.doubleFormat(input.text)
            self.pendingValue = inputValue
        }
    }

    private func executeOperation(tag: Int, pendingValue: Double, currentValue: Double) -> String? {
        switch tag {
        case 11:
            return numberFormater.amount(pendingValue + currentValue)
        case 12:
            return numberFormater.amount(pendingValue - currentValue)
        case 13:
           return numberFormater.amount(pendingValue * currentValue)
        case 14:
           return numberFormater.amount(pendingValue / currentValue)
        default:
            return numberFormater.amount(0)
        }
    }
}
