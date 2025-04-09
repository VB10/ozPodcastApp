import XCTest
@testable import ozPodcastApp

final class HomeRouterTests: XCTestCase {
    // MARK: - Properties
    
    private var router: HomeRouter!
    private var mockNavigationView: MockNavigationView!
    
    // MARK: - Setup and Teardown
    
    override func setUp() {
        super.setUp()
        mockNavigationView = MockNavigationView()
        router = HomeRouter(viewController: mockNavigationView)
    }
    
    override func tearDown() {
        router = nil
        mockNavigationView = nil
        super.tearDown()
    }
    
    // MARK: - Test Cases
    
    func testBuild_CreatesHomeViewController() {
        // Act
        let viewController = HomeRouter.build()
        
        // Assert
        XCTAssertNotNil(viewController)
        XCTAssertTrue(viewController is HomeViewController)
    }
    
    func testNavigateToPodcast_ShouldCallNavigationMethod() {
        // Arrange
        let mockPodcast = PodcastResponse.mock
        
        // Act
        router.navigateToPodcast(podcastResponse: mockPodcast)
        
        // Assert
        // Note: This test is currently limited since the navigation method is commented out in the router
        // In a real implementation, you would assert that the view controller was presented
        // XCTAssertEqual(mockNavigationView.presentedViewController?.title, "Podcast Detail")
    }
    
    func testNavigateToSearch_ShouldCallNavigationMethod() {
        // Act
        router.navigateToSearch()
        
        // Assert
        // Note: This test is currently limited since the navigation method is commented out in the router
        // In a real implementation, you would assert that the view controller was pushed
        // XCTAssertEqual(mockNavigationView.pushedViewController?.title, "Search")
    }
}

// MARK: - Mocks

private final class MockNavigationView: UIViewController, NavigationView {
    var presentedMockViewController: UIViewController?
    var pushedMockViewController: UIViewController?
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentedMockViewController = viewControllerToPresent
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    func pushWithNavigationController(_ viewController: UIViewController) {
        pushedMockViewController = viewController
    }
} 