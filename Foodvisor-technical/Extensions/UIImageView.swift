//
//  UIImageView.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 23/11/2020.
//
//

import UIKit

extension UIImageView {
    convenience init(image: UIImage?, contentMode cm: UIView.ContentMode) {
        self.init(image: image)
        self.contentMode = cm
    }
    
    @discardableResult func load(fileName: String) -> Bool {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false), let image = UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(fileName).path) {
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
            return true
        } else {
            return false
        }
    }
    
    func load(url: URL) {
        // Check if image is already downloaded
        if !load(fileName: url.fileName) {
            URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
                guard let data = data, let filename = response?.suggestedFilename, error == nil else { return }
                guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else { return }
                    do {
                        try data.write(to: directory.appendingPathComponent(filename)!)
                    } catch {
                        return
                    }
                DispatchQueue.main.async() { [weak self] in
                    self?.image = UIImage(data: data)
                }
            }).resume()
        }
    }
    
    func setPlaceholder() {
        DispatchQueue.main.async {
            self.image = #imageLiteral(resourceName: "noPicture")
            self.alpha = 0.1
        }
    }
}
