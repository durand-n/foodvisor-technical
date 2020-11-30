//
//  UIView.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 23/11/2020.
//
//

import UIKit

extension UIView {
    
    convenience init(backgroundColor: UIColor) {
        self.init()
        self.backgroundColor = backgroundColor
    }
    
    var cornerRadius: CGFloat? {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue ?? 0
            layer.masksToBounds = (newValue ?? CGFloat(0.0)) > CGFloat(0.0)
        }
    }
    
    func cornerRadius(usingCorners corners: CACornerMask, radius: CGFloat) {
        layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            layer.maskedCorners = corners
        }
    }
    
    open func addSubviews(_ views: [UIView]) {
        for i in 0..<views.count {
            addSubview(views[i])
        }
    }
    
    open func removeSubviews() {
        subviews.forEach { view in
            view.removeFromSuperview()
        }
    }
    
    open func fadeIn(withDuration: TimeInterval = 0.2, completion: ((Bool) -> Void)? = nil) {
        self.isHidden = false
        UIView.animate(withDuration: withDuration, delay: 0, options: [.curveEaseInOut], animations: {
            self.alpha = 1
        }, completion: completion)
    }
    
    open func fadeOut(withDuration: TimeInterval = 0.2, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: withDuration, delay: 0, options: [.curveEaseInOut], animations: {
            self.alpha = 0
        }, completion: { success in
            self.isHidden = true
            completion?(success)
        })
    }
        
    open func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
    
    open func removeShadow() {
        layer.shadowOpacity = 0.0
    }
    
    open func setConstraintsToSuperview() {
        guard let superview = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            self.leftAnchor.constraint(equalTo: superview.leftAnchor),
            self.rightAnchor.constraint(equalTo: superview.rightAnchor),
        ])
    }
    
    open func setConstraints(_ constraints: [NSLayoutConstraint]) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }
    
    open func setVerticalConstraints(aboveView: UIView, spacing: CGFloat, left: CGFloat, right: CGFloat, bottom: Bool = false, bottomMargin: CGFloat? = nil, height: CGFloat? = nil) {
        guard let superview = self.superview else { return }
        var constraints = [
            self.topAnchor.constraint(equalTo: superview == aboveView ? superview.topAnchor : aboveView.bottomAnchor, constant: spacing),
            self.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: left),
            self.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: right),
        ]
        if bottom {
            constraints.append(self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottomMargin ?? spacing))
        }
        
        if let height = height {
            constraints.append(self.heightAnchor.constraint(equalToConstant: height))
        }
        
        self.setConstraints(constraints)
    }
    
    open func setVerticalConstraints(aboveView: UIView, spacing: CGFloat, margins: CGFloat, bottom: Bool = false, height: CGFloat? = nil) {
        setVerticalConstraints(aboveView: aboveView, spacing: spacing, left: margins, right: -1 * margins , bottom: bottom, bottomMargin: spacing, height: height)
    }
}

