//
//  UIColor.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 23/11/2020.
//
//

import UIKit

extension UIColor {
    class var background: UIColor { return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) }
    class var primary: UIColor { return #colorLiteral(red: 0.2309178412, green: 0.8855846524, blue: 0.5457833409, alpha: 1) }
    class var secondary: UIColor { return #colorLiteral(red: 0.03648069501, green: 0.8261551261, blue: 0.6218194962, alpha: 1) }
    class var text: UIColor { return #colorLiteral(red: 0.2852340639, green: 0.2903764844, blue: 0.294526577, alpha: 1) }
    class var urgent: UIColor { return #colorLiteral(red: 0.8430811216, green: 0.2207605541, blue: 0.3205709755, alpha: 1) }
    
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}
