//
//  CalculatorButtonInput.swift
//  iOS Calculator
//
//  Created by Peter Lizak on 24/03/2020.
//  Copyright © 2020 Peter Lizak. All rights reserved.
//

import Foundation

struct CalculatorButtonInputModel {
    let style: CalculatorButtonInputStyle
    let isWideButton: Bool
    let title: String
    let tag: Int

    init(style: CalculatorButtonInputStyle, title: String, tag: Int, isWideButton: Bool = false) {
        self.isWideButton = isWideButton
        self.title = title
        self.style = style
        self.tag = tag
    }
}
