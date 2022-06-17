//
//  ManuallyInputViewController+Mapper.swift
//  SaintNexusExample
//
//  Created by Gyuni on 2022/06/05.
//

import UIKit

extension ManuallyInputViewController {
    func mapResultTextView() -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        textView.textColor = UIColor.secondaryLabel
        
        return textView
    }
    
    func mapInputTextField() -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .secondarySystemBackground
        textField.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        return textField
    }
    
    func mapButton() -> UIButton {
        let button = UIButton()
        button.configuration = UIButton.Configuration.filled()
        button.setTitle("긁어오기", for: .normal)
        return button
    }
}
