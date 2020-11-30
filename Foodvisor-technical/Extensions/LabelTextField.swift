//
//  LabelTextField.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 30/11/2020.
//

import UIKit



class LabelTextField: UIView {
    private var textField = UITextField()
    init(labelText: String) {
        super.init(frame: .zero)
        let label = UILabel()
        label.text = labelText
        
        self.addSubviews([label, textField])
        
        label.setConstraints([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.leftAnchor.constraint(equalTo: self.leftAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        label.setContentHuggingPriority(.required, for: .horizontal)
        
        textField.setConstraints([
            textField.topAnchor.constraint(equalTo: self.topAnchor),
            textField.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 4),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textField.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var text: String? {
        set(newText) {
            textField.text = newText
        }
        get {
            return textField.text
        }
    }
    
    var keyboardType: UIKeyboardType {
        set(type) {
            textField.keyboardType = type
        }
        get {
            return textField.keyboardType
        }
    }
    
    var borderStyle: UITextField.BorderStyle {
        set(style) {
            textField.borderStyle = style
        }
        get {
            return textField.borderStyle
        }
    }
}
