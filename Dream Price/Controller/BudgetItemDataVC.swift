//
//  BudgetItemDataVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 14.07.2020.
//

import UIKit

protocol TransportDelegate {
    func transport(string: String)
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
    
    var balanceLabelText: String?
    var nameLabelText: String?
    var budgetItemType: BudgetItemType?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BudgetPVC.keyboardDelegate = self
        
        changeTransactionButton.setTitle("-", for: .normal)
        self.balanceLabel.text = balanceLabelText
        self.budgetItemNameLabel.text = nameLabelText
        
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
        
    }
    
    func clearTransaction() {
        transactionLabel.text! = "0"
        transactionLabel.font = transactionLabel.font.withSize(64)
    }
    
    func updateTransaction(action: String) {
        print("Updating transaction")
        switch action {
        case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
            if transactionLabel.text?.count == 7 { return }
            
            if transactionLabel.text == "0" {
                transactionLabel.text! = action
            } else {
                transactionLabel.text! += action
            }
        case "-":
            if transactionLabel.text?.count == 1 {
                transactionLabel.text =  "0"
            } else {
                transactionLabel.text!.removeLast()
            }
        case "+":
            if transactionLabel.text == "0" {
                return
            } else {
                transactionLabel.text! = "0"
                print("Transaction sent")
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
        case 7:
            transactionLabel.font = transactionLabel.font.withSize(36)
        default:
            transactionLabel.font = transactionLabel.font.withSize(64)
        }
    }
    
    @IBAction func changeTransaction(_ sender: Any) {
        
        if changeTransactionButton.title(for: .normal) == "-" {
            BudgetItemDataVC.currentTransaction = "+"
        } else {
            BudgetItemDataVC.currentTransaction = "-"
        }
                
        changeTransactionButton.setTitle(BudgetItemDataVC.currentTransaction, for: .normal)
        BudgetItemDataVC.delegate?.transport(string: BudgetItemDataVC.currentTransaction)
    }
    
}
