//
//  CalculatorButton.swift
//  iOS Calculator
//
//  Created by Peter Lizak on 24/03/2020.
//  Copyright © 2020 Peter Lizak. All rights reserved.
//

import UIKit

class CalculatorButton: UIButton {

    private let style: CalculatorButtonInputStyle
    private let isWideButton: Bool
    init(style: CalculatorButtonInputStyle, isWideButton: Bool) {
        self.style = style
        self.isWideButton = isWideButton
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        titleLabel?.font = UIFont.systemFont(ofSize: 30)

        backgroundColor = style.backgroundColor
        setTitleColor(style.titleColor, for: .normal)
        setTitleColor(style.selectedTitleColor, for: .selected)

        if !isWideButton {
            heightAnchor.constraint(equalTo: widthAnchor).isActive = true
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = bounds.height / 2
    }



    override open var isSelected: Bool {
        didSet {
            if style == .action {
                UIView.animateKeyframes(withDuration: 0.45, delay: 0.0, options: .allowUserInteraction, animations: {
                    self.backgroundColor = self.isSelected ? self.style.selectedBackgroundColor : self.style.backgroundColor
                })
            }
        }
    }

    override open var isHighlighted: Bool {
        didSet {
            if style != .action {
                UIView.animateKeyframes(withDuration: 0.35, delay: 0.0, options: .allowUserInteraction, animations: {
                    self.backgroundColor = self.isHighlighted ? self.style.highLightedBackgroundColor : self.style.backgroundColor
                })
            }
        }
    }
}
