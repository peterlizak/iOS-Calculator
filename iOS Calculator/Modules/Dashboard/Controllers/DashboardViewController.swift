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
            // Pasting/copying should be enabled, for this one should implement the UITextField Delegate
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
    private lazy var calculatorLogic: CalculatorLogic = CalculatorLogic()
    private let stackViewSpacing: CGFloat = 15
    private var numberFormater = Formatter()


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

    // MARK: - Input handling
    @objc private func inputTapped(_ inputButton: CalculatorButton) {
        AudioServicesPlaySystemSound(calculatorButtonTapSound)
        handleInput(tag: inputButton.tag, input: input.text?.replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: " ", with: "") ?? "0")
        handleButtonHighLight(inputButton: inputButton)
    }

    private func handleInput(tag: Int, input: String) {
        let doubleValue = numberFormater.doubleFormat(input) ?? 0
        if (0...9).contains(tag) {
            updateNumber(tag: tag, stringValue: input)
        } else if tag == 10 {
            addComa(inputValue: input)
        } else if (11...14).contains(tag) {
            updateOperation(tag: tag, doubleInput: doubleValue)
        } else if tag == 15 {
            addPercentage(input: doubleValue)
        }  else if tag == 16 {
            addOposite(input: doubleValue)
        } else if tag == 17 {
            reset()
        } else if tag == 18 {
            calculateResult(input: doubleValue)
        }
    }

    private func updateNumber(tag: Int, stringValue: String) {
        if calculatorLogic.updateNumber(tag: tag) {
            updateInputWith(value: "\(tag)")
        } else {
            updateInputWith(value: stringValue + "\(tag)")
        }
    }

    private func addComa(inputValue: String) {
        if calculatorLogic.addComa() {
            if inputValue == "" {
                input.text = "0,"
            } else if !inputValue.contains("."), inputValue.count < 11  {
                input.text = inputValue + ","
            }
        } else {
            input.text = "0,"
        }
    }

    private func updateOperation(tag: Int, doubleInput: Double) {
        let result = calculatorLogic.updateOperation(tag: tag, input: doubleInput)
        updateInputWithDoubleValue(value: result)
    }

    private func addPercentage(input: Double) {
        let result = calculatorLogic.addPercentage(input: input)
        updateInputWithDoubleValue(value: result)
    }

    private func addOposite(input: Double) {
        let result = calculatorLogic.opposite(input: input)
        updateInputWithDoubleValue(value: result)
    }

    private func reset() {
        calculatorLogic.reset()
        updateInputWithDoubleValue(value: 0)
    }

    private func calculateResult(input: Double) {
        if let result = calculatorLogic.calculateResult(input: input) {
            updateInputWithDoubleValue(value: result)
        }
    }

    // MARK: - TextField updating
    private func updateInputWith(value: String) {
        let formater = numberFormater.inputFormaterFor(stringValue: value)

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
        input.text = numberFormater.amount(value)
    }

    // MARK: - UI changing actions
    private func handleButtonHighLight(inputButton: CalculatorButton) {
        for button in self.verticalStackView.findViews(subclassOf: CalculatorButton.self) {
            if button.isSelected {
                button.isSelected = false
            }
        }
        inputButton.isSelected = true
    }
}
