//
//  UserDataInputViewController+Mapper.swift
//  SaintNexusExample
//
//  Created by Gyuni on 2022/06/05.
//

import UIKit
import SaintNexus

extension UserDataInputViewController {
    func mapIDTextField() -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .secondarySystemBackground
        textField.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        textField.placeholder = "ID"
        textField.text = SaintNexus.shared.userData["id"]
        return textField
    }
    
    func mapPWTextField() -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .secondarySystemBackground
        textField.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        textField.placeholder = "PW"
        textField.text = SaintNexus.shared.userData["pw"]
        return textField
    }
}
