//
//  ETPickerCell.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 27.07.2020.
//

import UIKit
import RealmSwift

class ETPickerCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    let realm = try! Realm()
    
    var pickerMode: Int! {
        didSet {
            categories.removeAll()
            let categoriesRealm = realm.objects(RealmCategory.self)
            for object in categoriesRealm {
                categories.append(Category(categoryID: object.id, type: CategoryType(rawValue: object.type)!, title: object.title, sortInt: object.sortInt))
            }
            
            categories.sort(by: { $0.sortInt > $1.sortInt} )
            
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
    
    var categories = [Category]()
    
    var categoriesShown: [Category] = [Category(categoryID: "", type: .manage, title: "None", sortInt: 0)]

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
        if categoriesShown[row].categoryID != "" {
            delegate?.rewriteCategory(id: categoriesShown[row].categoryID)
        } else {
            delegate?.rewriteCategory(id: nil)
        }
    }

}
