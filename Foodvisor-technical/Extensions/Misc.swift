//
//  Misc.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 24/11/2020.
//

import UIKit
import CoreData

extension NSManagedObject {
    static func deleteAll(context: NSManagedObjectContext) throws {
        try context.execute(NSBatchDeleteRequest(fetchRequest: self.fetchRequest()))
        try context.save()
    }
}

extension Double {
    func halfRound() -> Double {
        return (self * 2).rounded() / 2
    }
}

extension URL {
    var fileName: String {
        return self.lastPathComponent
    }
}

extension UIImage {
    func convert(toSize size:CGSize) -> UIImage? {
        let imgRect = CGRect(origin: CGPoint(x:0.0, y:0.0), size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        self.draw(in: imgRect)
        let copied = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return copied
    }
}

func saveImage(image: UIImage, to filename: String) {
    guard let data = image.jpegData(compressionQuality: 0.0) else { return }
    guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else { return }
    do {
        try data.write(to: directory.appendingPathComponent(filename)!)
    } catch {
        return
    }
}
