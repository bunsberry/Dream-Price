//
//  BudgetItemDataVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 14.07.2020.
//

import UIKit

protocol TransportDelegate {
    func transportCurrentState(symbol: String, name: String)
    func transportTransactionData(number: Float, budgetID: String)
    func transportButtons(enabled: Int)
}

class BudgetItemDataVC: UIViewController, KeyboardDelegate {

    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var budgetItemView: UIView!
    @IBOutlet weak var changeTransactionButton: UIButton!
    @IBOutlet weak var transactionLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var budgetItemNameLabel: UILabel!
    
    public static var currentTransaction = "-"
    
    public static var delegate: TransportDelegate?
    
    var balance: Float = 0
    var nameLabelText: String!
    var budgetItemType: BudgetItemType!
    var index: Int?
    var budgetID: String!
    
    // MARK: View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeTransactionButton.setTitle("-", for: .normal)
        self.budgetItemNameLabel.text = nameLabelText
        updateBalance(balanceFloat: balance)
        
        if var localeCurrency = Locale.current.currencySymbol {
            if localeCurrency == "RUB" { localeCurrency = "₽" }
            currencyLabel.text = " \(localeCurrency)"
        } else {
            currencyLabel.text = " $"
        }
        
        if Settings.shared.recordCentsOn! {
            transactionLabel.text = "0.00"
            transactionLabel.font = transactionLabel.font.withSize(56)
        } else {
            transactionLabel.text = "0"
        }
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        switch self.budgetItemType {
        case .personal: gradient.colors = [UIColor(red: 0.608, green: 0.898, blue: 0.506, alpha: 1).cgColor, UIColor(red: 0.45, green: 0.792, blue: 0.443, alpha: 1).cgColor]
        case .project: gradient.colors = [UIColor(red: 0.898, green: 0.506, blue: 0.506, alpha: 1).cgColor, UIColor(red: 0.792, green: 0.443, blue: 0.443, alpha: 1).cgColor]
        case .dream: gradient.colors = [UIColor(red: 0.506, green: 0.616, blue: 0.898, alpha: 1).cgColor, UIColor(red: 0.443, green: 0.541, blue: 0.792, alpha: 1).cgColor]
        default: break
        }
        
        gradient.cornerRadius = 15
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.6, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.4, y: 1.0)
        gradient.frame = CGRect(x: 0.0,
                                y: 0.0,
                                width: self.view.frame.size.width * 0.75,
                                height: self.view.frame.size.width * 0.75 / 2)

        self.budgetItemView.layer.insertSublayer(gradient, at: 0)
        
        self.budgetItemView.layer.shadowColor = UIColor.secondaryLabel.cgColor
        self.budgetItemView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.budgetItemView.layer.shadowRadius = CGFloat(12)
        self.budgetItemView.layer.shadowOpacity = 0.25
        
        BudgetItemDataVC.delegate?.transportCurrentState(symbol: "-", name: nameLabelText)
        
    }
    
    func updateBalance(balanceFloat: Float) {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        let localeCode = Locale.current.currencyCode
        
        if localeCode == "RUB" {
            currencyFormatter.locale = Locale.init(identifier: "ru_RU") }
        else { currencyFormatter.locale = Locale.current }
        
        if Settings.shared.recordCentsOn! {
            currencyFormatter.maximumFractionDigits = 2
            currencyFormatter.minimumFractionDigits = 2
            let priceString = currencyFormatter.string(from: NSNumber(value: balanceFloat))!
            self.balanceLabel.text = "Баланс: \(priceString)"
        } else {
            let balance: Int = Int(balanceFloat)
            currencyFormatter.maximumFractionDigits = 0
            currencyFormatter.minimumFractionDigits = 0
            let priceString = currencyFormatter.string(from: NSNumber(value: balance))!
            self.balanceLabel.text = NSLocalizedString("Balance: ", comment: "") + priceString
        }
    }
    
    func reloadItems() {
        updateBalance(balanceFloat: balance)
        codeAmount += ""
    }
    
    // MARK: Update Balance Label
    
    private var codeAmount: String = "0" {
        didSet {
            if Settings.shared.recordCentsOn! {
                let codeAmountFloat: Float = Float(codeAmount)!
                transactionLabel.text = "\(codeAmountFloat / 100)"
                if codeAmount == "0" {
                    transactionLabel.text = "0.00"
                }
            } else {
                transactionLabel.text = codeAmount
            }
        }
    }
    
    func updateTransaction(action: String) {
        switch action {
        case "0":
            if codeAmount.count == 7 { return }
            
            if codeAmount == "0" {
                return
            } else {
                codeAmount += action
            }
        case "1", "2", "3", "4", "5", "6", "7", "8", "9":
            if codeAmount.count == 7 { return }
            
            if codeAmount == "0" {
                codeAmount = action
                BudgetItemDataVC.delegate?.transportButtons(enabled: 1)
            } else {
                codeAmount += action
            }
        case "-":
            if codeAmount.count == 1 {
                codeAmount =  "0"
                BudgetItemDataVC.delegate?.transportButtons(enabled: 0)
            } else {
                codeAmount.removeLast()
            }
        case "+":
            if codeAmount == "0" {
                return
            } else {
                if changeTransactionButton.title(for: .normal) == "-" {
                    balance -= Float(transactionLabel.text!)!
                    updateBalance(balanceFloat: balance)
                    BudgetItemDataVC.delegate?.transportTransactionData(number: -Float(transactionLabel.text!)!, budgetID: self.budgetID)
                } else {
                    balance += Float(transactionLabel.text!)!
                    updateBalance(balanceFloat: balance)
                    BudgetItemDataVC.delegate?.transportTransactionData(number: Float(transactionLabel.text!)!, budgetID: self.budgetID)
                }
                BudgetItemDataVC.delegate?.transportButtons(enabled: 0)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                    
                    self.budgetItemView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    
                    UIView.transition(with: self.transactionLabel, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        [weak self] in
                        self?.codeAmount = "0"
                }, completion: nil)
                    
                }, completion: {
                    (_) in
                    
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        
                        self.budgetItemView.transform = CGAffineTransform(scaleX: 1, y: 1)
                        
                    }, completion: nil)
                    
                })
            }
        default:
            print("Transaction switch failed")
        }
        
        switch transactionLabel.text?.count {
        case 1, 2, 3:
            transactionLabel.font = transactionLabel.font.withSize(64)
        case 4:
            transactionLabel.font = transactionLabel.font.withSize(56)
        case 5:
            transactionLabel.font = transactionLabel.font.withSize(48)
        case 6:
            transactionLabel.font = transactionLabel.font.withSize(42)
        case 7, 8:
            transactionLabel.font = transactionLabel.font.withSize(36)
        default:
            transactionLabel.font = transactionLabel.font.withSize(64)
        }
        
        // TODO: Update db balance
    }
    
    // MARK: Transaction Change Button
    
    @IBAction func changeTransaction(_ sender: Any) {
        
        if changeTransactionButton.title(for: .normal) == "-" {
            BudgetItemDataVC.currentTransaction = "+"
        } else {
            BudgetItemDataVC.currentTransaction = "-"
        }
                
        changeTransactionButton.setTitle(BudgetItemDataVC.currentTransaction, for: .normal)
        BudgetItemDataVC.delegate?.transportCurrentState(symbol: BudgetItemDataVC.currentTransaction, name: nameLabelText)
    }
    
}
