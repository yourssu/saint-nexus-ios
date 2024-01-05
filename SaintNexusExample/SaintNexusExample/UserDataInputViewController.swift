//
//  UserDataInputViewController.swift
//  SaintNexusExample
//
//  Created by Gyuni on 2022/06/05.
//

import UIKit
import SaintNexus

class UserDataInputViewController: UIViewController {

    private lazy var idTextField = mapIDTextField()
    private lazy var pwTextField = mapPWTextField()
    private lazy var yearTextField = mapYearTextField()
    private lazy var semesterTextField = mapSemesterTextField()
    private lazy var spacer = UIView()
    private lazy var stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UserData"
        view.backgroundColor = .systemBackground
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 24, bottom: 20, right: 24)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(idTextField)
        stackView.addArrangedSubview(pwTextField)
        stackView.addArrangedSubview(yearTextField)
        stackView.addArrangedSubview(semesterTextField)
        stackView.addArrangedSubview(spacer)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        idTextField.delegate = self
        pwTextField.delegate = self
        yearTextField.delegate = self
        semesterTextField.delegate = self
    }
}

extension UserDataInputViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case idTextField:
            SaintNexus.shared.userData["id"] = textField.text
        case pwTextField:
            SaintNexus.shared.userData["pw"] = textField.text
        case yearTextField:
            SaintNexus.shared.userData["year"] = textField.text
        case semesterTextField:
            SaintNexus.shared.userData["semester"] = textField.text
        default:
            return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
