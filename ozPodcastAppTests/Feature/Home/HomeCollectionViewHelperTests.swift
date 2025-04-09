import XCTest
@testable import ozPodcastApp

final class HomeCollectionViewHelperTests: XCTestCase {
    // MARK: - Properties
    
    private var helper: HomeCollectionViewHelper!
    private var mockCollectionView: MockCollectionView!
    private var mockDelegate: MockHomeCollectionViewHelperDelegate!
    
    // MARK: - Setup and Teardown
    
    override func setUp() {
        super.setUp()
        mockCollectionView = MockCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        mockDelegate = MockHomeCollectionViewHelperDelegate()
        helper = HomeCollectionViewHelper(collectionView: mockCollectionView)
        helper.delegate = mockDelegate
    }
    
    override func tearDown() {
        helper = nil
        mockCollectionView = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    // MARK: - Test Cases
    
    func testUpdateItems_ShouldReloadCollectionView() {
        // Arrange
        let mockPodcasts = [PodcastResponse.mock]
        
        // Act
        helper.updateItems(mockPodcasts)
        
        // Assert
        XCTAssertTrue(mockCollectionView.reloadDataCalled)
    }
    
    func testNumberOfItemsInSection_ShouldReturnCorrectCount() {
        // Arrange
        let mockPodcasts = [PodcastResponse.mock, PodcastResponse.mock]
        helper.updateItems(mockPodcasts)
        
        // Act
        let count = helper.collectionView(mockCollectionView, numberOfItemsInSection: 0)
        
        // Assert
        XCTAssertEqual(count, mockPodcasts.count)
    }
    
    func testSizeForItemAt_ShouldReturnCorrectSize() {
        // Arrange
        let mockWidth: CGFloat = 300
        mockCollectionView.mockBounds = CGRect(x: 0, y: 0, width: mockWidth, height: 500)
        let layout = UICollectionViewFlowLayout()
        
        // Act
        let size = helper.collectionView(mockCollectionView, layout: layout, sizeForItemAt: IndexPath(item: 0, section: 0))
        
        // Assert
        // Calculate expected width: (total width - insets) / items per row
        let expectedWidth = mockWidth / 3
        // Height is width * ratio (2.0)
        let expectedHeight = expectedWidth * 2.0
        XCTAssertEqual(size.width, expectedWidth, accuracy: 0.1)
        XCTAssertEqual(size.height, expectedHeight, accuracy: 0.1)
    }
    
    func testDidSelectItemAtIndexPath_ShouldCallDelegate() {
        // Arrange
        let mockPodcasts = [PodcastResponse.mock]
        helper.updateItems(mockPodcasts)
        let indexPath = IndexPath(item: 0, section: 0)
        
        // Act
        helper.collectionView(mockCollectionView, didSelectItemAt: indexPath)
        
        // Assert
        XCTAssertTrue(mockDelegate.didSelectItemCalled)
        XCTAssertEqual(mockDelegate.selectedItem?.id, mockPodcasts[0].id)
    }
    
    func testDidSelectItemAtIndexPath_WithInvalidIndex_ShouldNotCallDelegate() {
        // Arrange
        let mockPodcasts = [PodcastResponse.mock]
        helper.updateItems(mockPodcasts)
        let indexPath = IndexPath(item: 1, section: 0) // Invalid index
        
        // Act
        helper.collectionView(mockCollectionView, didSelectItemAt: indexPath)
        
        // Assert
        XCTAssertFalse(mockDelegate.didSelectItemCalled)
        XCTAssertNil(mockDelegate.selectedItem)
    }
}

// MARK: - Mocks

private final class MockCollectionView: UICollectionView {
    var reloadDataCalled = false
    var mockBounds: CGRect = .zero
    
    override func reloadData() {
        reloadDataCalled = true
    }
    
    override var bounds: CGRect {
        get {
            return mockBounds.isEmpty ? super.bounds : mockBounds
        }
        set {
            super.bounds = newValue
        }
    }
}

private final class MockHomeCollectionViewHelperDelegate: HomeCollectionViewHelperDelegate {
    var didSelectItemCalled = false
    var selectedItem: PodcastResponse?
    
    func didSelectItem(item: PodcastResponse) {
        didSelectItemCalled = true
        selectedItem = item
    }
} 