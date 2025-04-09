//
//  UIWindow+Extension.swift
//  ozPodcastApp
//
//  Created by vb10 on 8.11.2024.
//

import UIKit
extension UIWindow {
    
    /// Get current window 
    static var current: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: \.isKeyWindow)
    }
}
