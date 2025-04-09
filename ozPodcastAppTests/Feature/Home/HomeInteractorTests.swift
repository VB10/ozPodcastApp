import XCTest
@testable import ozPodcastApp

final class HomeInteractorTests: XCTestCase {
    // MARK: - Properties
    
    private var interactor: HomeInteractor!
    private var mockGeneralService: MockGeneralService!
    private var mockOutput: MockHomeInteractorOutput!
    
    // MARK: - Setup and Teardown
    
    override func setUp() {
        super.setUp()
        mockGeneralService = MockGeneralService()
        mockOutput = MockHomeInteractorOutput()
        interactor = HomeInteractor(generalService: mockGeneralService)
        interactor.output = mockOutput
    }
    
    override func tearDown() {
        interactor = nil
        mockGeneralService = nil
        mockOutput = nil
        super.tearDown()
    }
    
    // MARK: - Test Cases
    
    func testGetPodcasts_WhenServiceReturnsData_ShouldReturnPodcasts() async {
        // Arrange
        let mockPodcasts = [PodcastResponse.mock]
        mockGeneralService.mockPodcastResult = mockPodcasts
        
        // Act
        let result = await interactor.getPodcasts()
        
        // Assert
        XCTAssertTrue(mockGeneralService.podcastCalled)
        XCTAssertEqual(result.count, mockPodcasts.count)
        XCTAssertEqual(result.first?.id, mockPodcasts.first?.id)
    }
    
    func testGetPodcasts_WhenServiceReturnsNil_ShouldReturnEmptyArray() async {
        // Arrange
        mockGeneralService.mockPodcastResult = nil
        
        // Act
        let result = await interactor.getPodcasts()
        
        // Assert
        XCTAssertTrue(mockGeneralService.podcastCalled)
        XCTAssertTrue(result.isEmpty)
    }
    
    func testGetPodcasts_ShouldReturnMockData() async {
        // Note: This test confirms the current implementation that returns mock data
        // In a real production app, this would be tested differently
        
        // Act
        let result = await interactor.getPodcasts()
        
        // Assert
        XCTAssertFalse(result.isEmpty)
        XCTAssertEqual(result.first?.id, PodcastResponse.mock.id)
    }
}

// MARK: - Mocks

private final class MockGeneralService: GeneralServiceProtocol {
    var podcastCalled = false
    var mockPodcastResult: [PodcastResponse]?
    
    func podcast() async -> [PodcastResponse]? {
        podcastCalled = true
        return mockPodcastResult
    }
}

private final class MockHomeInteractorOutput: HomeInteractorOutput {
    var podcastsFetchedCalled = false
    var podcasts: [PodcastResponse] = []
    var podcastsFetchFailedCalled = false
    var error: Error?
    
    func podcastsFetched(_ podcasts: [PodcastResponse]) {
        podcastsFetchedCalled = true
        self.podcasts = podcasts
    }
    
    func podcastsFetchFailed(_ error: Error) {
        podcastsFetchFailedCalled = true
        self.error = error
    }
} 