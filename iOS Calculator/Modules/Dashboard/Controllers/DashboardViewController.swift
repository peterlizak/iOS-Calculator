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
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = stackViewSpacing
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var input: UITextField = {
        let input = UITextField()
        input.translatesAutoresizingMaskIntoConstraints = false
        input.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        input.font = UIFont.systemFont(ofSize: (UIScreen.main.bounds.width / 100) * 25, weight: .thin)
        input.contentVerticalAlignment = .bottom
        input.adjustsFontSizeToFitWidth = true
        // Pasting/copying should be enabled, for this one should implement the UITextField Delegate
        input.isUserInteractionEnabled = false
        input.tintColor = backgroundColor
        input.textColor = UIColor.white
        input.textAlignment = .right
        input.minimumFontSize = 30
        return input
    }()

    // MARK: - Properties
    private var horizontalStackView: UIStackView {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.spacing = stackViewSpacing
        stackView.axis = .horizontal
        stackView.alignment = .fill
        return stackView
    }
    private let stackViewSpacing = (UIScreen.main.bounds.width / 100) * 3.5
    private let bottomSpacing = (UIScreen.main.bounds.height / 100) * 3
    private let backgroundColor = UIColor.black

    private var calculatorInput: [[CalculatorButtonInputModel]] = CalculatorInput().input
    private lazy var calculatorLogic: CalculatorLogic = CalculatorLogic()
    private let numberFormater = Formatter()

    private weak var lastActiveOperatorButton: CalculatorButton?
    private var selectLastActiveOperatorButton: Bool = false
    private weak var clearButton: CalculatorButton?

    private let calculatorButtonTapSound: SystemSoundID = 1104

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupContent()
    }

    // MARK: - View Setup
    private func setupView() {
        input.backgroundColor = backgroundColor
        view.backgroundColor = backgroundColor
    }

    private func setupContent() {
        view.addSubview(input)
        view.addSubview(verticalStackView)
        addConstraints()
        setupCalculatorView()
    }

    private func setupCalculatorView() {
        for row in calculatorInput {
            let stackView = horizontalStackView
            for item in row {
                let button = setupButtonCalculator(for: item)
                stackView.addArrangedSubview(button)

                if item.tag == 17 {
                    clearButton = button
                }
                if item.isWideButton {
                    button.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5, constant: -5).isActive = true
                }
            }
            verticalStackView.addArrangedSubview(stackView)
        }
    }

    private func setupButtonCalculator(for input: CalculatorButtonInputModel) -> CalculatorButton {
           let button = CalculatorButton(style: input.style, isWideButton: input.isWideButton)
           button.addTarget(self, action: #selector(inputTapped), for: .touchUpInside)
           button.setTitle(input.title, for: .normal)
           button.tag = input.tag
           return button
       }

    private func addConstraints() {
        input.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        input.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35).isActive = true
        input.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        input.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

        verticalStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -bottomSpacing).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        verticalStackView.topAnchor.constraint(equalTo: input.bottomAnchor, constant: 10).isActive = true
        let verticalStackViewBottomAnchor = verticalStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomSpacing)
        verticalStackViewBottomAnchor.priority = UILayoutPriority(rawValue: 950)
        verticalStackViewBottomAnchor.isActive = true
    }

    // MARK: - Input handling
    @objc private func inputTapped(_ inputButton: CalculatorButton) {
        AudioServicesPlaySystemSound(calculatorButtonTapSound)
        let inputValue = prepareInputForProcessing(inputValue: input.text ?? "0")
        handleInput(tag: inputButton.tag, input: inputValue)
        handleButtonHighLight(inputButton: inputButton)

        if (11...14).contains(inputButton.tag) {
            lastActiveOperatorButton = inputButton
        }
    }

    private func prepareInputForProcessing(inputValue: String) -> String {
        inputValue.replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: " ", with: "")
    }

    private func handleInput(tag: Int, input: String) {
        let doubleValue = numberFormater.stringToDouble(input) ?? 0
        if (0...9).contains(tag) {
            updateNumber(tag: tag, stringValue: input)
        } else if tag == 10 {
            addComa(inputValue: input)
        } else if (11...14).contains(tag) {
            updateOperation(tag: tag, input: doubleValue)
        } else if tag == 15 {
            addPercentage(input: doubleValue)
        } else if tag == 16 {
            addOposite(input: doubleValue)
        } else if tag == 17 {
            clearOrReset(input: input)
        } else if tag == 18 {
            calculateResult(input: doubleValue)
        }
        setClearButtonTitle()
    }

    private func updateNumber(tag: Int, stringValue: String) {
        if calculatorLogic.updateNumber(tag: tag) {
            updateInputWithString(value: "\(tag)")
        } else {
            if (stringValue + "\(tag)").count < 10 {
                updateInputWithString(value: stringValue + "\(tag)")
            }
        }
    }

    private func addComa(inputValue: String) {
        if calculatorLogic.addComa() {
            if inputValue == "" {
                input.text = "0,"
            } else if !inputValue.contains("."), inputValue.count < 9 {
                input.text = inputValue + ","
            }
        } else {
            input.text = "0,"
        }
    }

    private func updateOperation(tag: Int, input: Double) {
        if let result = calculatorLogic.updateOperation(tag: tag, input: input) {
            updateInputWithDoubleValue(value: result)
        }
    }

    private func addPercentage(input: Double) {
        let result = calculatorLogic.addPercentage(input: input)
        updateInputWithDoubleValue(value: result)
    }

    private func addOposite(input: Double) {
        let result = calculatorLogic.opposite(input: input)
        updateInputWithDoubleValue(value: result)
    }

    private func clearOrReset( input: String) {
        if input != "0", input.count > 0 && calculatorLogic.isUserTyping {
            selectLastActiveOperatorButton = true
        } else {
            calculatorLogic.reset()
        }
        updateInputWithDoubleValue(value: 0)

    }

    private func setClearButtonTitle() {
        if (input.text == "0" || input.text == "") && calculatorLogic.canDisplayCButton {
            clearButton?.setTitle("AC", for: .normal)
        } else {
            clearButton?.setTitle("C", for: .normal)
        }
    }

    private func calculateResult(input: Double) {
        if let result = calculatorLogic.calculateResult(input: input) {
            updateInputWithDoubleValue(value: result)
            lastActiveOperatorButton = nil
        }
    }

    // MARK: - TextField updating
    private func updateInputWithString(value: String) {
        let formater = numberFormater.userInputFormaterFor(stringValue: value)

        guard let doubleValue = Double(value) else {
            print("Update number: unable to parse String input to Double")
            return
        }

        guard let formatedValue = formater.string(from: NSNumber(value: doubleValue)) else {
            print("Update number: number formater is unable to parse Double to String")
            return
        }
        input.text = formatedValue
    }

    private func updateInputWithDoubleValue(value: Double) {
        input.text = numberFormater.doubleToString(value)
    }

    // MARK: - UI changing actions
    private func handleButtonHighLight(inputButton: CalculatorButton) {
        for button in self.verticalStackView.findViews(subclassOf: CalculatorButton.self) where button.isSelected {
            button.isSelected = false
        }
        inputButton.isSelected = true

        if selectLastActiveOperatorButton {
            lastActiveOperatorButton?.isSelected = true
            selectLastActiveOperatorButton = false
        }
    }
}
