import UIKit

// Define layout constants needed by the helper
private enum Layout {
    static let collectionItemsPerRow: CGFloat = 3
    static let itemHeightToWidthRatio: CGFloat = 2.0
}

// Define delegate protocol
protocol HomeCollectionViewHelperDelegate: AnyObject {
    func didSelectItem(item: PodcastResponse)
}

// Make helper conform to UICollectionViewDelegate as well
final class HomeCollectionViewHelper: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private var items: [PodcastResponse] = []
    private weak var collectionView: UICollectionView?
    // Add delegate property
    weak var delegate: HomeCollectionViewHelperDelegate?

    // Initialize with the collection view it will manage
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self // Set helper as delegate
        // Register cell here for encapsulation
        collectionView.register(NewPodcasCollectionCell.self,
                                forCellWithReuseIdentifier: NewPodcasCollectionCell.reuseIdentifier)
    }

    // Method to update the data and reload the collection view
    func updateItems(_ newItems: [PodcastResponse]) {
        self.items = newItems
        runOnMainSafety { [weak self] in
            self?.collectionView?.reloadData()
        }
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NewPodcasCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: NewPodcasCollectionCell.reuseIdentifier, for: indexPath)
        cell.configure(with: items[indexPath.row])
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let layout = collectionViewLayout as? UICollectionViewFlowLayout
        let sectionInsets = layout?.sectionInset ?? .zero
        let spacing = layout?.minimumInteritemSpacing ?? 0

        let totalSpacing = sectionInsets.left + sectionInsets.right +
            (spacing * (Layout.collectionItemsPerRow - 1))
        let availableWidth = collectionView.bounds.width - totalSpacing
        let widthPerItem = availableWidth / Layout.collectionItemsPerRow
        let heightPerItem = widthPerItem * Layout.itemHeightToWidthRatio

        return CGSize(width: widthPerItem, height: heightPerItem)
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row < items.count else { return }
        let selectedItem = items[indexPath.row]
        // Call the delegate method
        delegate?.didSelectItem(item: selectedItem)
    }
}

// Helper function (assuming it's defined elsewhere or we define it globally/extension)
// If not already global, add this or ensure it's accessible
func runOnMainSafety(_ block: @escaping () -> Void) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.async(execute: block)
    }
} 
