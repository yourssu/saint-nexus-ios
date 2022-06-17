//
//  FeatureViewController+Mapper.swift
//  SaintNexusExample
//
//  Created by Gyuni on 2022/05/22.
//

import UIKit

extension FeatureViewController {
    func mapCoverView() -> UIView {
        let view = UIView()
        
        view.backgroundColor = .black.withAlphaComponent(0.15)
        
        let label = UILabel()
        label.text = "Cover View"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0),
        ])
        
        return view
    }
    
    func mapFooterView() -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        textView.textColor = UIColor.secondaryLabel
        
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 24, bottom: 24, right: 20)
        return textView
    }
}
