//
//  BudgetItemDataVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 14.07.2020.
//

import UIKit

class BudgetItemDataVC: UIViewController {

    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var budgetItemView: UIView!
    @IBOutlet weak var changeTransactionButton: UIButton!
    @IBOutlet weak var transactionLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var budgetItemNameLabel: UILabel!
    
    public static var transactionSymbol = "-"
    
    var balanceLabelText: String?
    var nameLabelText: String?
    var budgetItemType: BudgetItemType?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0,
                                y: 0.0,
                                width: self.budgetItemView.frame.size.width,
                                height: self.budgetItemView.frame.size.height)

        self.budgetItemView.layer.insertSublayer(gradient, at: 0)
        
        
        
    }
    
    @IBAction func changeTransaction(_ sender: Any) {
        
        if changeTransactionButton.title(for: .normal) == "-" {
            BudgetItemDataVC.transactionSymbol = "+"
        } else {
            BudgetItemDataVC.transactionSymbol = "-"
        }
        
        changeTransactionButton.setTitle(BudgetItemDataVC.transactionSymbol, for: .normal)
    }
    
}
