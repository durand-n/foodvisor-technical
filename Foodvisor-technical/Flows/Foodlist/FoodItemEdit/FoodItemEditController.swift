//
//  FoodItemEditController.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 28/11/2020.
//

import UIKit



protocol FoodItemEditView: BaseView {
    var onSave: (() -> Void)? { get set }
    
    var onPresentImagePicker: ((@escaping (UIImage?) -> Void) -> Void)? { get set }
}

class FoodItemEditController: UIViewController, FoodItemEditView {
    
    
    
    private var viewModel: FoodItemEditViewModelType
    private let contentView = UIView(backgroundColor: .white)
    private var pictureView = UIImageView()
    private var nameField = UITextField(placeholder: "nom")
    private var caloriesField = UITextField(placeholder: "calories")
    private var carbsField = UITextField(placeholder: "carbs")
    private var fatField = UITextField(placeholder: "fat")
    private var fibersField = UITextField(placeholder: "fibers")
    private var proteinsField = UITextField(placeholder: "proteins")
    private var errorLabel = UILabel(title: "Le nom et les calories sont obligatoires", type: .medium, color: .urgent, size: 14, lines: 0, alignment: .center)
    private var typeControl = UISegmentedControl()
    
    
    var onSave: (() -> Void)?
    var onPresentImagePicker: ((@escaping (UIImage?) -> Void) -> Void)?
    
    init(viewModel: FoodItemEditViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let saveButton = UIButton(title: "Sauvegarder", font: .regular, fontSize: 16, textColor: .white, backgroundColor: .primary)
        let quitButton = UIButton(illu: UIImage(systemName: "xmark") ?? UIImage(), contentMode: .scaleAspectFit, tintColor: .secondary)
        let pictureButton = UIButton(title: "Choisir une photo", font: .regular, textColor: .secondary)

    
        overrideUserInterfaceStyle = .light
        
        if let url = viewModel.thumbnail {
            pictureView.load(url: url)
        } else if let name = viewModel.fileName {
            pictureView.load(fileName: name)
        }
        pictureView.contentMode = .scaleAspectFit
        pictureView.cornerRadius = 8
        
        typeControl = UISegmentedControl(items: viewModel.typeList)
        typeControl.selectedSegmentIndex = viewModel.typeIndex
        
        saveButton.addTarget(self, action: #selector(savePushed), for: .touchUpInside)
        pictureButton.addTarget(self, action: #selector(showLibrary), for: .touchUpInside)
        quitButton.addTarget(self, action: #selector(quitPushed), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.addSubview(contentView)
        contentView.addSubviews([pictureView, pictureButton, typeControl, saveButton, quitButton, errorLabel])
        contentView.cornerRadius = 12
        errorLabel.fadeOut(withDuration: 0)
        
        designFields()
        
        contentView.setConstraints([
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            contentView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30)
        ])
        
        pictureView.setConstraints([
            pictureView.heightAnchor.constraint(equalToConstant: 70),
            pictureView.widthAnchor.constraint(equalToConstant: 70),
            pictureView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            pictureView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16)
        ])
        
        pictureButton.setConstraints([
            pictureButton.leftAnchor.constraint(equalTo: pictureView.rightAnchor, constant: 4),
            pictureButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            pictureButton.centerYAnchor.constraint(equalTo: pictureView.centerYAnchor)
        ])
        
        
        quitButton.setConstraints([
            quitButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            quitButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
        ])
        
        errorLabel.setVerticalConstraints(aboveView: typeControl, spacing: 8, margins: 16)
        
        saveButton.setConstraints([
            saveButton.topAnchor.constraint(equalTo: typeControl.bottomAnchor, constant: 30),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            saveButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            saveButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16)
        ])
        saveButton.cornerRadius = 8
    }
    
    func designFields() {
        let nameLabel = UILabel(title: "plat", type: .regular, color: .label, size: 11, lines: 1, alignment: .left)
        let caloriesLabel = UILabel(title: "calories", type: .regular, color: .label, size: 11, lines: 1, alignment: .left)
        let carbsLabel = UILabel(title: "carbs", type: .regular, color: .label, size: 11, lines: 1, alignment: .left)
        let fatLabel = UILabel(title: "graisse", type: .regular, color: .label, size: 11, lines: 1, alignment: .left)
        let fibersLabel = UILabel(title: "fibres", type: .regular, color: .label, size: 11, lines: 1, alignment: .left)
        let proteinsLabel = UILabel(title: "protéines", type: .regular, color: .label, size: 11, lines: 1, alignment: .left)
        
        contentView.addSubviews([nameField, nameLabel, caloriesLabel, caloriesField, carbsField, carbsLabel, fatField, fatLabel, fibersField, fibersLabel, proteinsField, proteinsLabel])
        
        nameField.text = viewModel.name
        nameField.borderStyle = .roundedRect
        nameField.addDoneButtonOnKeyboard()
        
        caloriesField.text = viewModel.calories
        caloriesField.borderStyle = .roundedRect
        caloriesField.keyboardType = .numberPad
        caloriesField.addDoneButtonOnKeyboard()
        
        carbsField.text = viewModel.carbs
        carbsField.keyboardType = .decimalPad
        carbsField.borderStyle = .roundedRect
        carbsField.addDoneButtonOnKeyboard()
        
        fatField.text = viewModel.fat
        fatField.borderStyle = .roundedRect
        fatField.keyboardType = .decimalPad
        fatField.addDoneButtonOnKeyboard()
        
        fibersField.text = viewModel.fibers
        fibersField.borderStyle = .roundedRect
        fibersField.keyboardType = .decimalPad
        fibersField.addDoneButtonOnKeyboard()
        
        proteinsField.text = viewModel.proteins
        proteinsField.borderStyle = .roundedRect
        proteinsField.keyboardType = .decimalPad
        proteinsField.addDoneButtonOnKeyboard()
        
        nameLabel.setVerticalConstraints(aboveView: pictureView, spacing: 16, left: 24, right: 16)
        nameField.setVerticalConstraints(aboveView: nameLabel, spacing: 2, margins: 16, height: 30)
        caloriesLabel.setVerticalConstraints(aboveView: nameField, spacing: 8, left: 24, right: 16)
        caloriesField.setVerticalConstraints(aboveView: caloriesLabel, spacing: 2, margins: 16, height: 30)
        carbsLabel.setVerticalConstraints(aboveView: caloriesField, spacing: 8, left: 24, right: 16)
        carbsField.setVerticalConstraints(aboveView: carbsLabel, spacing: 2, margins: 16, height: 30)
        fatLabel.setVerticalConstraints(aboveView: carbsField, spacing: 8, left: 24, right: 16)
        fatField.setVerticalConstraints(aboveView: fatLabel, spacing: 2, margins: 16, height: 30)
        fibersLabel.setVerticalConstraints(aboveView: fatField, spacing: 8, left: 24, right: 16)
        fibersField.setVerticalConstraints(aboveView: fibersLabel, spacing: 2, margins: 16, height: 30)
        proteinsLabel.setVerticalConstraints(aboveView: fibersField, spacing: 8, left: 24, right: 16)
        proteinsField.setVerticalConstraints(aboveView: proteinsLabel, spacing: 2, margins: 16, height: 30)
        typeControl.setVerticalConstraints(aboveView: proteinsField, spacing: 8, margins: 16)
    }

    
    @objc func savePushed() {
        if viewModel.setData(name: nameField.text ?? "", calories: caloriesField.text ?? "", carbs: carbsField.text ?? "", fat: fatField.text ?? "", fibers: fibersField.text ?? "", proteins: proteinsField.text ?? "", type: typeControl.selectedSegmentIndex) {
            errorLabel.fadeOut()
            self.onSave?()
        } else {
            errorLabel.fadeIn()
        }
    }
    
    @objc func showLibrary() {
        self.onPresentImagePicker?() { [weak self] image in
            if let image = image {
                self?.pictureView.image = image
                self?.viewModel.setImage(image: image)
            }
        }
    }
    
    @objc func quitPushed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard !nameField.isFirstResponder && !caloriesField.isFirstResponder else { return }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 100
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func dismissMyKeyboard() {
          view.endEditing(true)
      }
    
}
