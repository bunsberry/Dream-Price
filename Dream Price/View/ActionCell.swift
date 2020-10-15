//
//  ActionCell.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 26.08.2020.
//

import UIKit
import RealmSwift

class ActionCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var checkmarkButton: UIButton!
    @IBOutlet weak var taskTextView: UITextView!
    var actionID: String!
    
    var textDidChange: (() -> Void)? = nil
    
    var delegate: ProjectEditDelegate?
    let realm = try! Realm()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        taskTextView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textViewDidBeginEditing(_ textField: UITextView) {
        
        if textField.textColor == .tertiaryLabel {
            textField.text = nil
            textField.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type task here..."
            textView.textColor = .tertiaryLabel
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let actions = realm.objects(RealmAction.self)
        
        for action in actions {
            if action.id == actionID {
                try! realm.write {
                    action.text = textView.text
                }
            }
        }
        
        textDidChange?()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let  char = text.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")

        if (isBackSpace == -92) && textView.text.isEmpty {
            delegate?.deleteAction(id: actionID)
            return false
        }
        return true
    }
    
    @IBAction func checkmarkTapped(_ sender: UIButton) {
        var dateCompleted: Date? = nil
        
        if sender.isSelected {
            sender.isSelected = false
            dateCompleted =  nil
        } else {
            sender.isSelected = true
            dateCompleted = Date()
        }
        
        let actions = realm.objects(RealmAction.self)
        
        for action in actions {
            if action.id == actionID {
                try! realm.write {
                    action.isCompleted = sender.isSelected
                    action.dateCompleted = dateCompleted as NSDate?
                }
            }
        }
    }
}
