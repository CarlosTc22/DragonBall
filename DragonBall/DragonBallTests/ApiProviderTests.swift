//
//  ApiProviderTests.swift
//  DragonBallTests
//
//  Created by Juan Carlos Torrejón Cañedo on 3/3/24.
//

import XCTest
@testable import DragonBall

final class ApiProviderTests: XCTestCase {
    private var sut: ApiProviderProtocol!
    
    override func setUp() {
        super.setUp()
        let secureDataProvider = SecureDataProvider()
        sut = MockApiService(secureDataProvider: secureDataProvider)
    }
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_givenApiProvider_whenLoginWithUserAndPassword_thenGetValidToken() throws {
        let handler: (Notification) -> Bool = { notification in
            let token = notification.userInfo?[NotificationCenter.tokenKey] as? String
            XCTAssertNotNil(token)
            XCTAssertNotEqual(token ?? "", "")
            
            return true
        }
        
        let expectation = self.expectation(
            forNotification: NotificationCenter.apiLoginNotification,
            object: nil,
            handler: handler
        )
        
        sut.login(for: "carlostc22@gmail.com", with: "25071993")
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_givenApiProvider_whenGetAllHeroes_ThenHeroesExists() throws {
        let expectation = self.expectation(description: "Fetch one hero data")
        
        self.sut.getHeroes(nil) { heroes in
            XCTAssertNotEqual(heroes.count, 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_givenApiProvider_whenGetOneHero_ThenHeroExists() throws {
        let expectation = self.expectation(description: "Fetch one hero data")
        
        let heroName = "Goku"
        self.sut.getHeroes(heroName) { heroes in
            XCTAssertEqual(heroes.count, 1)
            XCTAssertEqual(heroes.first?.name ?? "", heroName)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_givenApiProvider_whenGetOneHero_ThenHeroNotExists() throws {
        let expectation = self.expectation(description: "Fetch one hero data")
        
        let heroName = "Thanos"
        self.sut.getHeroes(heroName) { heroes in
            XCTAssertEqual(heroes.count, 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testLoginWithInvalidCredentials_thenReceiveAuthenticationError() {
        let expectation = self.expectation(description: "Authentication error received")
        (sut as? MockApiService)?.mockResponse = .error("Authentication failed")
        
        let handler: (Notification) -> Void = { notification in
            XCTAssertNotNil(notification.userInfo?["error"])
            expectation.fulfill()
        }
        
        NotificationCenter.default.addObserver(forName: NotificationCenter.apiLoginNotification, object: nil, queue: nil, using: handler)
        
        sut.login(for: "wrongUser", with: "wrongPassword")
        wait(for: [expectation], timeout: 2.0)
        
        NotificationCenter.default.removeObserver(self, name: NotificationCenter.apiLoginNotification, object: nil)
    }
    
    
    func testGetHeroesWithMalformedResponse_thenHandleGracefully() {
        let expectation = self.expectation(description: "Handle malformed response gracefully")
        (sut as? MockApiService)?.mockResponse = .malformedResponse
        
        sut.getHeroes(nil) { heroes in
            XCTAssertTrue(heroes.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testGetHeroesWithNon200Response_thenHandleError() {
        let expectation = self.expectation(description: "Handle non-200 HTTP status code")
        (sut as? MockApiService)?.mockResponse = .non200StatusCode(404)
        
        sut.getHeroes(nil) { heroes in
            XCTAssertTrue(heroes.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testGetHeroesNetworkRequestTimeout_thenHandleError() {
        let expectation = self.expectation(description: "Handle network request timeout")
        (sut as? MockApiService)?.mockResponse = .error("Timeout")
        
        sut.getHeroes(nil) { heroes in
            XCTAssertTrue(heroes.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}
