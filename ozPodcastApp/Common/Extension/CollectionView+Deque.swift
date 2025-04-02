//
//  CollectionView+Deque.swift
//  ozPodcastApp
//
//  Created by vb10 on 14.03.2025.
//

import UIKit

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue cell with identifier: \(identifier)")
        }
        return cell
    }
}
