//
//  CameraView.swift
//  test-assignment
//
//  Created by Vlad on 12.06.2025.
//

import SwiftUI
import UIKit

struct CameraView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    
    var onPhotoTaken: (UIImage) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.modalPresentationStyle = .fullScreen
        
        return picker
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(onPhotoTaken: onPhotoTaken)
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let onPhotoTaken: (UIImage) -> Void
        
        init(onPhotoTaken: @escaping (UIImage) -> Void) {
            self.onPhotoTaken = onPhotoTaken
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                onPhotoTaken(image)
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
