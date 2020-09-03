//
//  ActionCell.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 26.08.2020.
//

import UIKit

class ActionCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var checkmarkButton: UIButton!
    @IBOutlet weak var taskTextView: UITextView!
    var actionID: String!
    
    var textDidChange: (() -> Void)? = nil
    
    var delegate: ProjectEditDelegate?

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
        // TODO: db saving
        textDidChange?()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let  char = text.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")

        if (isBackSpace == -92) && textView.text.isEmpty {
            print("should be removed")
            delegate?.deleteAction(id: actionID)
            return false
        }
        return true
//        if text == "\r" {
//            print("should be removed")
//            return false
//        }
//        return true
    }
    
    @IBAction func checkmarkTapped(_ sender: UIButton) {
        // TODO: db write that it's done
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }

}
