//
//  UIFont+Extension.swift
//  ozPodcastApp
//
//  Created by vb10 on 8.11.2024.
//
import UIKit
extension UIFont {
    
    
    /// Bolder font 
    var bolded: UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(.traitBold) else {
            return self
        }
        
        return UIFont(descriptor: descriptor, size: pointSize)
    }
}
