//
//  ValueChangeIC.swift
//  Dream Price Companion Extension
//
//  Created by Kostya Bunsberry on 21.07.2020.
//

import WatchKit

protocol FirstDelegate {
    func dismissFirst()
}

class ValueChangeIC: WKInterfaceController, SecondDelegate {
    
    @IBOutlet var valueLabel: WKInterfaceLabel!
    @IBOutlet var budgetNameLabel: WKInterfaceLabel!
    @IBOutlet var nextButton: WKInterfaceButton!
    
    var crownAccumulator = 0.0
    let currencyFormatter = NumberFormatter()
    
    var transactionValue: Int! {
        didSet {
            if transactionValue == 0 {
                valueLabel.setText(String(describing: currencyFormatter.string(from: NSNumber(value:transactionValue))!))
                valueLabel.setTextColor(UIColor.darkGray)
                nextButton.setEnabled(false)
            } else if transactionValue > 0 {
                valueLabel.setText("+\(String(describing: currencyFormatter.string(from: NSNumber(value:transactionValue))!))")
                valueLabel.setTextColor(UIColor.green)
                nextButton.setEnabled(true)
            } else {
                valueLabel.setText("\(String(describing: currencyFormatter.string(from: NSNumber(value:transactionValue))!))")
                valueLabel.setTextColor(UIColor.red)
                nextButton.setEnabled(true)
            }
        }
    }
    
    static public var budget: Budget?
    static public var delegate: FirstDelegate?

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        setTitle("Транзакция")
        crownSequencer.delegate = self
        
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        if Locale.current.currencyCode == "RUB" {
            currencyFormatter.locale = Locale(identifier: "ru_RU")
        }
        currencyFormatter.minimumFractionDigits = 0
        currencyFormatter.maximumFractionDigits = 0
        
        transactionValue = 0
        
        if let name = ValueChangeIC.budget?.name {
            budgetNameLabel.setText(name)
        }
    }
    
    override func willActivate() {
        super.willActivate()
        crownSequencer.focus()
    }
    
    @IBAction func nextPage() {
        presentController(withName: "categorySelect", context: nil)
        CategoryIC.delegate = self
        CategoryIC.budgetID = ValueChangeIC.budget?.id
        CategoryIC.transactionValue = transactionValue
    }

    func dismissSecond() {
        ValueChangeIC.delegate?.dismissFirst()
    }
}

extension ValueChangeIC: WKCrownDelegate {
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        
        crownAccumulator += rotationalDelta
        
        if crownAccumulator > 0.025 {
            transactionValue += 1
            crownAccumulator = 0.0
        } else if crownAccumulator < -0.025 {
            transactionValue -= 1
            crownAccumulator = 0.0
        }
    }
}
