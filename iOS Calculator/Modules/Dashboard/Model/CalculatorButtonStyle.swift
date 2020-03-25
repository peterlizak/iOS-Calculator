//
//  CalculatorButtonStyle.swift
//  iOS Calculator
//
//  Created by Peter Lizak on 24/03/2020.
//  Copyright © 2020 Peter Lizak. All rights reserved.
//

import Foundation
import UIKit

enum CalculatorButtonInputStyle {
    case equalSign
    case subAction
    case action
    case value
}

extension CalculatorButtonInputStyle {

    // MARK: - Normal state
    var backgroundColor: UIColor {
        switch self {
        case .equalSign, .action:
            return UIColor.orange
        case .subAction:
            return UIColor.lightGray
        case .value:
            return UIColor.darkGray
        }
    }

    var titleColor: UIColor {
        switch self {
        case .equalSign, .action, .value:
            return UIColor.white
        case .subAction:
            return UIColor.black
        }
    }

    // MARK: - HighLight
    var highLightedBackgroundColor: UIColor? {
        switch self {
        case .subAction, .equalSign:
            return UIColor.white
        case .value:
            return UIColor.lightGray
        default:
            return nil
        }
    }

    // MARK: - Selected
    var selectedTitleColor: UIColor? {
        switch self {
        case .action:
            return UIColor.orange
        default:
            return nil
        }
    }

    var selectedBackgroundColor: UIColor? {
        if self == .action {
            return UIColor.white
        }

        return nil
    }
}
