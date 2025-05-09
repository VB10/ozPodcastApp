import XCTest
@testable import ozPodcastApp

final class HomePresenterTests: XCTestCase {
    // MARK: - Properties
    
    private var presenter: HomePresenter!
    private var mockInteractor: MockHomeInteractor!
    private var mockRouter: MockHomeRouter!
    private var mockView: MockHomeView!
    
    // MARK: - Setup and Teardown
    
    override func setUp() {
        super.setUp()
        mockInteractor = MockHomeInteractor()
        mockRouter = MockHomeRouter()
        mockView = MockHomeView()
        presenter = HomePresenter(
            interactor: mockInteractor,
            router: mockRouter,
            view: mockView
        )
    }
    
    override func tearDown() {
        presenter = nil
        mockInteractor = nil
        mockRouter = nil
        mockView = nil
        super.tearDown()
    }
    
    // MARK: - Test Cases
    
    func testViewDidLoad_ShouldShowLoading() async {
        // Arrange
        let mockPodcasts = [PodcastResponse.mock]
        mockInteractor.mockPodcasts = mockPodcasts
        
        // Act
        presenter.viewDidLoad()
        
        // Wait for async task to complete
        let expectation = XCTestExpectation(description: "Loading completed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1.0)
        
        // Assert
        XCTAssertTrue(mockView.didShowLoadingCalled)
        XCTAssertTrue(mockView.isLoading)
        XCTAssertTrue(mockView.didUpdatePodcastsCalled)
        XCTAssertEqual(mockView.updatedPodcasts, mockPodcasts)
        XCTAssertFalse(mockView.isLoading)
    }
    
    func testDidSelectPodcast_ShouldNavigateToPodcast() {
        // Arrange
        let mockPodcast = PodcastResponse.mock
        
        // Act
        presenter.didSelectPodcast(mockPodcast)
        
        // Assert
        XCTAssertTrue(mockRouter.didNavigateToPodcastCalled)
        XCTAssertEqual(mockRouter.navigatedPodcast?.id, mockPodcast.id)
    }
    
    func testDidTapSearch_ShouldNavigateToSearch() {
        // Act
        presenter.didTapSearch()
        
        // Assert
        XCTAssertTrue(mockRouter.didNavigateToSearchCalled)
    }
}

// MARK: - Mocks

private final class MockHomeView: HomeViewInput {
    var updatedPodcasts: [PodcastResponse] = []
    var isLoading = false
    var didShowLoadingCalled = false
    var didUpdatePodcastsCalled = false
    
    func updatePodcastsCollectionView(items: [PodcastResponse]) {
        didUpdatePodcastsCalled = true
        updatedPodcasts = items
    }
    
    func showLoading(_ isLoading: Bool) {
        didShowLoadingCalled = true
        self.isLoading = isLoading
    }
}

private final class MockHomeInteractor: HomeInteractorProtocol {
    var mockPodcasts: [PodcastResponse] = []
    var didGetPodcastsCalled = false
    
    func getPodcasts() async -> [PodcastResponse] {
        didGetPodcastsCalled = true
        return mockPodcasts
    }
}

private final class MockHomeRouter: HomeRouterInput {
    var didNavigateToPodcastCalled = false
    var didNavigateToSearchCalled = false
    var navigatedPodcast: PodcastResponse?
    
    func navigateToPodcast(podcastResponse: PodcastResponse) {
        didNavigateToPodcastCalled = true
        navigatedPodcast = podcastResponse
    }
    
    func navigateToSearch() {
        didNavigateToSearchCalled = true
    }
} 