//
//  ImagePicker.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 01/12/2020.
//

import UIKit

open class ImagePickerHandler: NSObject {

    public var didSelect: ((_ image: UIImage?) -> Void)?

    init(sourceType: UIImagePickerController.SourceType) {
        super.init()

        Constants.pickerController.sourceType = sourceType
        Constants.pickerController.delegate = self
        Constants.pickerController.allowsEditing = true
        Constants.pickerController.mediaTypes = ["public.image"]
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)

        self.didSelect?(image)
    }
}

extension ImagePickerHandler: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        pickerController(picker, didSelect: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let resized = image.convert(toSize: CGSize(width: 400, height: 400)) {
            didSelect?(resized)
        }
    }
}

extension ImagePickerHandler: UINavigationControllerDelegate {

}
