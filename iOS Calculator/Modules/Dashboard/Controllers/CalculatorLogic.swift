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

    // MARK: - Properties
    private var numberFormater = Formatter()
    private var waitingActionOperationTag: Int?
    private var pendingOperationTag: Int?
    private var pendingValue: Double?
    private var inputValue: Double?

    // MARK: - Public properties
    var isUserTyping = true

    var canDisplayCButton: Bool {
        return pendingOperationTag == nil && waitingActionOperationTag == nil &&
            pendingValue == nil && inputValue == nil
    }

    // MARK: - Public functions
    func updateOperation(tag: Int, input: Double) -> Double? {
        if (pendingOperationTag == nil) || !isUserTyping {
            setWaitingOperationTag(tag: tag, pending: input, current: nil)
            return nil
        }

        guard let pendingTag = pendingOperationTag, let pendigValue = pendingValue else {
            print("Update Operation error: pendingOperationTag or pendingValue is nil")
            return nil
        }

        let resultValue = executeOperation(tag: pendingTag, pendingValue: pendigValue, currentValue: input)
        setWaitingOperationTag(tag: tag, pending: resultValue, current: input)
        return resultValue
    }

    func calculateResult(input: Double) -> Double? {
        if inputValue == nil {
            inputValue = input
        }

        guard let operationTag = pendingOperationTag ?? waitingActionOperationTag else {
            print("Calculate result error: Operation tag not found")
            return nil
        }

        guard let pendingValue = pendingValue, let inputValue = inputValue else {
            print("Calculate result error: pending or input value is nil")
            return nil
        }

        let resultVaue = executeOperation(tag: operationTag, pendingValue: pendingValue, currentValue: inputValue)
        updateValuesAfterResult(pending: resultVaue, current: inputValue)

        return resultVaue
    }

    func updateNumber(tag: Int) -> Bool {
        if waitingActionOperationTag != nil {
            setPendingOperationTag()
            return true
        }

        if !isUserTyping {
            reset()
            return true
        }

        return false
    }

    func addPercentage(input: Double) -> Double {
        return input / 100.0
    }

    func opposite(input: Double) -> Double {
       return input * -1.0
    }

    func reset() {
        waitingActionOperationTag = nil
        pendingOperationTag = nil
        pendingValue = nil
        inputValue = nil
        isUserTyping = true
    }

    func addComa() -> Bool {
        if !isUserTyping {
            setPendingOperationTag()
            return false
        }
        return true
    }

    // MARK: - Private functions
    private func executeOperation(tag: Int, pendingValue: Double, currentValue: Double) -> Double {
        switch tag {
        case 11:
            return pendingValue + currentValue
        case 12:
            return pendingValue - currentValue
        case 13:
           return pendingValue * currentValue
        case 14:
           return pendingValue / currentValue
        default:
            return 0
        }
    }

    private func setWaitingOperationTag(tag: Int, pending: Double, current: Double?) {
        waitingActionOperationTag = tag
        pendingOperationTag = nil
        pendingValue = pending
        inputValue = current
        isUserTyping = false
    }

    private func setPendingOperationTag() {
        pendingOperationTag = waitingActionOperationTag
        waitingActionOperationTag = nil
        isUserTyping = true
    }

    private func updateValuesAfterResult(pending: Double, current: Double) {
        pendingValue = pending
        inputValue = current
        isUserTyping = false
    }
}
