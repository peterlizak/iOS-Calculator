//
//  DashboardViewController.swift
//  iOS Calculator
//
//  Created by Peter Lizak on 23/03/2020.
//  Copyright © 2020 Peter Lizak. All rights reserved.
//

import UIKit
import AVFoundation

class DashboardViewController: UIViewController {

    // MARK: - UIObjects
    @IBOutlet weak var verticalStackView: UIStackView! {
        didSet {
            verticalStackView.distribution = .fillEqually
        }
    }
    @IBOutlet weak var input: UITextField! {
        didSet {
            input.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            input.tintColor = UIColor.black
            // Actually a pasting/copying should be enabled, for this one should implement the UITextField Delegate
            input.isUserInteractionEnabled = false
        }
    }

    // MARK: - Properties
    private var horizontalStackView: UIStackView {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.spacing = stackViewSpacing
        stackView.axis = .horizontal
        stackView.alignment = .fill
        return stackView
    }
    private var calculatorInput: [[CalculatorButtonInput]] = CalculatorInput().input
    private let calculatorButtonTapSound: SystemSoundID = 1104
    private var calculatorLogic = CalculatorLogic()
    private let stackViewSpacing: CGFloat = 15

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupContent()
    }

    // MARK: - Setup
    private func setupView() {
        view.backgroundColor = UIColor.black
        input.backgroundColor = UIColor.black
    }

    private func setupContent() {
        for row in calculatorInput {
            let stackView = horizontalStackView
            for item in row {
                let button = setupButton(for: item)
                stackView.addArrangedSubview(button)

                if item.isWideButton {
                    button.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5, constant: -5).isActive = true
                }
            }
            verticalStackView.addArrangedSubview(stackView)
        }
    }

    private func setupButton(for input: CalculatorButtonInput) -> CalculatorButton{
        let button = CalculatorButton(style: input.style, isWideButton: input.isWideButton)
        button.addTarget(self, action: #selector(inputTapped), for: .touchUpInside)
        button.setTitle(input.title, for: .normal)
        button.tag = input.tag
        return button
    }

    // MARK: - Actions
    @objc private func inputTapped(_ inputButton: CalculatorButton) {
        AudioServicesPlaySystemSound(calculatorButtonTapSound)
        calculatorLogic.handleInput(tag: inputButton.tag, input: input)
        handleButtonHighLight(inputButton: inputButton)
    }

    private func handleButtonHighLight(inputButton: CalculatorButton) {
        for button in self.verticalStackView.findViews(subclassOf: CalculatorButton.self) {
            if button.isSelected {
                button.isSelected = false
            }
        }
        inputButton.isSelected = true
    }
}
