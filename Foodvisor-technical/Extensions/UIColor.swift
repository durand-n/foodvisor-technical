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
    class var primary: UIColor { return #colorLiteral(red: 0.2479153275, green: 0.8894758821, blue: 0.5404686332, alpha: 1) }
    class var secondary: UIColor { return #colorLiteral(red: 0.03648069501, green: 0.8261551261, blue: 0.6218194962, alpha: 1) }
    class var text: UIColor { return #colorLiteral(red: 0.3382632732, green: 0.368088156, blue: 0.5840685964, alpha: 1) }
    class var urgent: UIColor { return #colorLiteral(red: 0.8430811216, green: 0.2207605541, blue: 0.3205709755, alpha: 1) }
    
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}
