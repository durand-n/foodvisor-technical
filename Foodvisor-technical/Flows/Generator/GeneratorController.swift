//
//  GeneratorController.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 02/12/2020.
//

import UIKit

protocol GeneratorView: BaseView {}

class GeneratorController: UIViewController, GeneratorView {
    private var viewModel: GeneratorViewModelType
    private var caloriesField = UITextField(placeholder: "kcal")
    private let caloriesLabel = UILabel(title: "Indiquez le nombre de calories visé", type: .medium, color: .label, size: 15, lines: 0, alignment: .center)
    private let generatorStartButton = UIButton(title: "Génerer", font: .bold, fontSize: 14, textColor: .white, backgroundColor: .primary)
    private let generatorResults = GeneratorResultsView()
    
    init(viewModel: GeneratorViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        title = "Générateur"
        overrideUserInterfaceStyle = .light
        view.addSubviews([caloriesField, caloriesLabel, generatorStartButton, generatorResults])
        
        caloriesField.setConstraints([
            caloriesField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            caloriesField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            caloriesField.widthAnchor.constraint(equalToConstant: 150),
            caloriesField.heightAnchor.constraint(equalToConstant: 30)
        ])
        caloriesField.addDoneButtonOnKeyboard()
        
        caloriesLabel.setVerticalConstraints(aboveView: caloriesField, spacing: 8, margins: 32)
        generatorStartButton.setVerticalConstraints(aboveView: caloriesLabel, spacing: 32, margins: 45, height: 45)
        generatorResults.setConstraintsToSuperview()
        generatorStartButton.cornerRadius = 6
        generatorStartButton.addTarget(self, action: #selector(generate), for: .touchUpInside)
        generatorResults.didRetry = { [weak self] in
            guard let self = self else { return }
            self.caloriesLabel.fadeIn()
            self.caloriesField.fadeIn()
            self.generatorStartButton.fadeIn()
            self.generatorResults.fadeOut()
        }
        
        caloriesField.borderStyle = .roundedRect
        caloriesField.keyboardType = .numberPad
        
        generatorResults.fadeOut(withDuration: 0, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func generate() {
        guard let text = caloriesField.text, !text.isEmpty, let value = Int(text) else {
            self.showError(message: "Vous devez renseigner le champ calories")
            return
        }

        let data = viewModel.calculateBestMeal(calories: value)
        if let results = data.result {
            caloriesField.fadeOut()
            caloriesLabel.fadeOut()
            generatorStartButton.fadeOut()
            generatorResults.setContent(starter: results.starter, dish: results.dish, dessert: results.dessert, total: results.total, above: results.isAbove)
            generatorResults.fadeIn(withDuration: 0)
            generatorResults.animate()
        } else {
            self.showError(message: data.error ?? "Erreur inconnue")
        }

    }
}

class GeneratorResultsView: UIView {
    let starterView = FoodGeneratorCard()
    let dishView = FoodGeneratorCard()
    let dessertView = FoodGeneratorCard()
    let threshold = UILabel(title: "", type: .regular, color: .primary, size: 14, lines: 1, alignment: .center)
    
    var didRetry: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
        let retry = UIButton(title: "Effacer", font: .regular, fontSize: 14, textColor: .secondary, backgroundColor: .clear)
        self.addSubviews([ threshold, starterView, dishView, dessertView, retry])
        
        starterView.setConstraints([
            starterView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 6.0),
            starterView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 32),
            starterView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -32),
            starterView.bottomAnchor.constraint(equalTo: dishView.topAnchor, constant: -30)
        ])
        
        dishView.setConstraints([
            dishView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 6.0),
            dishView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 32),
            dishView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -32),
            dishView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -30),
            dishView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
        
        dessertView.setVerticalConstraints(aboveView: dishView, spacing: 30, left: 32, right: -32, height: UIScreen.main.bounds.height / 6.0)
        threshold.setVerticalConstraints(aboveView: self, spacing: 16, left: 32, right: -32)
        retry.setVerticalConstraints(aboveView: dessertView, spacing: 8, left: 40, right: -40, height: 45)
        retry.addTarget(self, action: #selector(retryPushed), for: .touchUpInside)
        
        starterView.addShadow(offset: CGSize(width: 0, height: 5), color: .black, opacity: 0.2, radius: 5)
        dishView.addShadow(offset: CGSize(width: 0, height: 5), color: .black, opacity: 0.2, radius: 5)
        dessertView.addShadow(offset: CGSize(width: 0, height: 5), color: .black, opacity: 0.2, radius: 5)
        starterView.alpha = 0.0
        dishView.alpha = 0.0
        dessertView.alpha = 0.0
    }
    
    func setContent(starter: FoodDataRepresentable, dish: FoodDataRepresentable, dessert: FoodDataRepresentable, total: String, above: Bool) {
        starterView.setContent(data: starter)
        dishView.setContent(data: dish)
        dessertView.setContent(data: dessert)
        threshold.text = total
        threshold.textColor = above ? .red : .primary
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate() {
        var delayCounter = 0
        for view in self.subviews {
            view.alpha = 0
            view.transform = CGAffineTransform(translationX: 0, y: 20)
            UIView.animate(withDuration: 1.3, delay: 0.08 * Double(delayCounter), usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                view.transform = CGAffineTransform.identity
                view.alpha = 1.0
            }, completion: nil)
            delayCounter += 1
        }
    }
    
    @objc func retryPushed() {
        self.didRetry?()
    }
}

class FoodGeneratorCard: UIView {
    private var nameLabel = UILabel(title: "", type: .bold, color: .white, size: 22, lines: 0, alignment: .center)
    private var foodImageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    private var caloriesLabel = UILabel(title: "", type: .regular, color: .text, size: 16, lines: 1, alignment: .left)
    private let gradientLayer = CAGradientLayer()
    
    init() {
        super.init(frame: .zero)
        addSubviews([foodImageView, nameLabel, caloriesLabel])
        foodImageView.setConstraintsToSuperview()
        nameLabel.setConstraintsToSuperview()
        foodImageView.layer.addSublayer(gradientLayer)
        foodImageView.clipsToBounds = true
    }
    
    func setContent(data: FoodDataRepresentable) {

        gradientLayer.frame = foodImageView.bounds
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.black.withAlphaComponent(0.8).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.3)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        

        nameLabel.text = data.name + "\n" + data.calories
        if let url = data.pictureUrl {
            foodImageView.load(url: url)
        } else if let name = data.pictureName {
            foodImageView.load(fileName: name)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
