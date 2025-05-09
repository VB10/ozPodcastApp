//
//  ProductRadius.swift
//  ozPodcastApp
//
//  Created by vb10 on 29.11.2024.
//

import UIKit
enum ProductRadius: Int {
    case small = 4
    case medium = 8
    case large = 12
    
    var size: CGFloat {
        CGFloat(self.rawValue)
    }
}
