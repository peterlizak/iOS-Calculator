//
//  CalculatorInput.swift
//  iOS Calculator
//
//  Created by Peter Lizak on 24/03/2020.
//  Copyright © 2020 Peter Lizak. All rights reserved.
//

import Foundation

class CalculatorInput {
    var input: [[CalculatorButtonInputModel]] {
        let row1 = [CalculatorButtonInputModel(style: .subAction, title: "AC", tag: 17),CalculatorButtonInputModel(style: .subAction, title: "±", tag: 16), CalculatorButtonInputModel(style: .subAction, title: "%", tag: 15), CalculatorButtonInputModel(style: .action, title: "÷",tag: 14)]
        let row2 = [CalculatorButtonInputModel(style: .value, title: "7", tag: 7),CalculatorButtonInputModel(style: .value, title: "8", tag: 8), CalculatorButtonInputModel(style: .value, title: "9", tag: 9), CalculatorButtonInputModel(style: .action, title: "×",tag: 13)]
        let row3 = [CalculatorButtonInputModel(style: .value, title: "4", tag: 4),CalculatorButtonInputModel(style: .value, title: "5", tag: 5), CalculatorButtonInputModel(style: .value, title: "6", tag: 6), CalculatorButtonInputModel(style: .action, title: "-",tag: 12)]
        let row4 = [CalculatorButtonInputModel(style: .value, title: "1", tag: 1),CalculatorButtonInputModel(style: .value, title: "2", tag: 2), CalculatorButtonInputModel(style: .value, title: "3", tag: 3), CalculatorButtonInputModel(style: .action, title: "+",tag: 11)]
        let row5 = [CalculatorButtonInputModel(style: .value, title: "0", tag: 0, isWideButton: true),CalculatorButtonInputModel(style: .value, title: ",", tag: 10), CalculatorButtonInputModel(style: .equalSign, title: "=", tag: 18)]

        return [row1, row2, row3, row4, row5]
    }
}
 
