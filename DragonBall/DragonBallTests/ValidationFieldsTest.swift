//
//  ValidationFieldsTest.swift
//  DragonBallTests
//
//  Created by Juan Carlos Torrejón Cañedo on 3/3/24.
//

import XCTest
@testable import DragonBall

final class ValidationFieldsTests: XCTestCase {
    private var sut: LoginViewModel!

    override  func setUp() {
        let secureData = SecureDataProvider()
        sut = LoginViewModel(apiProvider: ApiProvider(secureDataProvider: secureData),
                             secureDataProvider: secureData)
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_givenValidEmail_whenIsValid_thenTrue() throws {
        let validEmail = "d.jardon@gmail.com"
        let isEmailValid = sut.isValid(email: validEmail)

        XCTAssertTrue(isEmailValid)
    }

    func test_givenValidEmail_whenNotValid_thenFalse() throws {
        let invalidEmail = "d.jardongmail.com"
        let isEmailValid = sut.isValid(email: invalidEmail)

        XCTAssertFalse(isEmailValid)
    }
}
