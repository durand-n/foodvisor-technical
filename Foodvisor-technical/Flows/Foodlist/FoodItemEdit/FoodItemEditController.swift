//
//  FoodItemEditController.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 28/11/2020.
//

import UIKit

protocol FoodItemEditView: BaseView {
    var onSave: (() -> Void)? { get set }
}

class FoodItemEditController: UIViewController, FoodItemEditView {
    private var viewModel: FoodItemEditViewModelType
    private var nameField = UITextField()
    var onSave: (() -> Void)?
    
    init(viewModel: FoodItemEditViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let contentView = UIView(backgroundColor: .white)
        let saveButton = UIButton(backgroundColor: .primary)
        
        nameField.placeholder = "Plat"
        nameField.text = viewModel.name
        
        saveButton.addTarget(self, action: #selector(savePushed), for: .touchUpInside)
        
        view.addSubview(contentView)
        contentView.addSubviews([nameField, saveButton])
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        contentView.setConstraints([
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 300),
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            contentView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30)
        ])
        
        nameField.setConstraints([
            nameField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            nameField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
        ])
        
        saveButton.setConstraints([
            saveButton.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 30),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            saveButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            saveButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16)
        ])
        saveButton.cornerRadius = 8
    }
    
    @objc func savePushed() {
        viewModel.setData(name: nameField.text ?? "")
        self.onSave?()
    }
}
