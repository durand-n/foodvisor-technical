//
//  FoodListCell.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 24/11/2020.
//

import UIKit
import AlamofireImage

class FoodlistCell: UITableViewCell {
    private var nameLabel = UILabel(title: "", type: .bold, color: .white, size: 22, lines: 0, alignment: .left)
    private var foodImageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    private var caloriesLabel = UILabel(title: "210 Kcal", type: .regular, color: .text, size: 16, lines: 1, alignment: .left)
    let gradientLayer = CAGradientLayer()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let card = UIView(backgroundColor: .white)
        card.cornerRadius = 12
        
        selectionStyle = .none
        foodImageView.clipsToBounds = true
        contentView.addSubview(card)
        card.addSubviews([foodImageView, nameLabel, caloriesLabel])
        
        card.setConstraints([
            card.heightAnchor.constraint(equalToConstant: 200),
            card.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            card.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        foodImageView.setConstraints([
            foodImageView.leftAnchor.constraint(equalTo: card.leftAnchor),
            foodImageView.rightAnchor.constraint(equalTo: card.rightAnchor),
            foodImageView.topAnchor.constraint(equalTo: card.topAnchor),
            foodImageView.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -60)
        ])
        
        nameLabel.setConstraints([
            nameLabel.leftAnchor.constraint(equalTo: card.leftAnchor, constant: 8),
            nameLabel.bottomAnchor.constraint(equalTo: foodImageView.bottomAnchor, constant: -4),
            nameLabel.rightAnchor.constraint(equalTo: card.rightAnchor, constant: -8)
        ])
        
        caloriesLabel.setConstraints([
            caloriesLabel.leftAnchor.constraint(equalTo: card.leftAnchor, constant: 8),
            caloriesLabel.topAnchor.constraint(equalTo: foodImageView.bottomAnchor, constant: 16),
        ])
        
        foodImageView.layer.addSublayer(gradientLayer)
        foodImageView.cornerRadius = 12
        foodImageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        card.addShadow(offset: CGSize(width: 0, height: 5), color: .black, opacity: 0.2, radius: 5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContent(data: FoodDataRepresentable) {
        nameLabel.text = data.name
        if let url = data.pictureUrl {
            foodImageView.af.setImage(withURL: url, cacheKey: data.pictureUrl?.absoluteString, completion: nil)
        }
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        gradientLayer.frame = foodImageView.bounds
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.black.withAlphaComponent(0.8).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.3)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
    }

}

