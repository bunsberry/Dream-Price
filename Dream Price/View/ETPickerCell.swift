//
//  ETPickerCell.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 27.07.2020.
//

import UIKit

class ETPickerCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var pickerView: UIPickerView!
    var pickerMode: Int! {
        didSet {
            if pickerMode == 0 {
                for category in categories {
                    if category.type == .spending { categoriesShown.append(category) }
                }
                for category in categories {
                    if category.type == .budget { categoriesShown.append(category) }
                }
            } else if pickerMode == 1 {
                for category in categories {
                    if category.type == .earning { categoriesShown.append(category) }
                }
                for category in categories {
                    if category.type == .budget { categoriesShown.append(category) }
                }
            }
        }
    }
    var delegate: TransactionDelegate?
    
    var categories = [
        Category(categoryID: UUID().uuidString, type: .spending, title: "Groceries", sortInt: 0),
        Category(categoryID: UUID().uuidString, type: .earning, title: "Work", sortInt: 0),
        Category(categoryID: UUID().uuidString, type: .budget, title: "Budget", sortInt: 0)
    ]
    
    var categoriesShown: [Category] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoriesShown.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoriesShown[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.rewriteCategory(id: categoriesShown[row].categoryID)
    }

}
