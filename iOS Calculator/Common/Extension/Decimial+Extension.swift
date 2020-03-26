//
//  Decimial+Extension.swift
//  iOS Calculator
//
//  Created by Peter Lizak on 26/03/2020.
//  Copyright © 2020 Peter Lizak. All rights reserved.
//

import Foundation

extension Decimal {
    var significantFractionalDecimalDigits: Int {
        return max(-exponent, 0)
    }
}
