//
//  SecureDataProvideTests.swift
//  DragonBallTests
//
//  Created by Juan Carlos Torrejón Cañedo on 3/3/24.
//

import XCTest
@testable import DragonBall

final class SecureDataProvideTests: XCTestCase {
    private var sut: SecureDataProviderProtocol!

    override func setUp() {
        sut = SecureDataProvider()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_givenSecureDataProvide_whenLoadToken_thenGetStoredToken() throws {
        let token = "123456abcde"
        sut.save(token: token)
        let tokenLoaded = sut.getToken()

        XCTAssertEqual(token, tokenLoaded)
    }
}

