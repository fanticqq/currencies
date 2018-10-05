//
//  CurrenciesCalculatorTests.swift
//  CurrenciesCalculatorTests
//
//  Created by i.zarubin on 05/10/2018.
//  Copyright © 2018 i.zarubin. All rights reserved.
//

import XCTest
@testable import CurrenciesCalculator

class CurrenciesServiceTests: XCTestCase {
    var networkClient: NetworkClientMock!
    var service: CurrenciesService!

    override func setUp() {
        networkClient = NetworkClientMock()
        service = CurrenciesService(networkClient: networkClient)
    }

    override func tearDown() {
        networkClient = nil
        service = nil
    }

    func testThatServiceObtainsDataSuccessfully() {
        let givenJSON: [String: Any] = JSONProvider.json(from: "DummyJSON")
        let expectedCurrencies = EntityProvider.currencies()
        let serviceExpectation = expectation(description: "CurrenciesServiceExpectation")
        
        networkClient.expectedResult = Result<[String: Any]>.success(givenJSON)

        service.obtainCurrencies(for: "EUR") { (result) in
            switch result {
            case .success(let currencies):
                XCTAssertTrue(Thread.current.isMainThread)
                XCTAssertEqual(expectedCurrencies, currencies)
                serviceExpectation.fulfill()
            case .error(_):
                serviceExpectation.fulfill()
                XCTFail()
            }
        }
        wait(for: [serviceExpectation], timeout: 5)
    }
    
    func testThatServiceThrowsErrorWhenDataIsIncomplete() {
        let givenJSON: [String: Any] = ["base": "EUR", "date": "2018-09-06"]
        let serviceExpectation = expectation(description: "CurrenciesServiceExpectation")
        
        networkClient.expectedResult = Result<[String: Any]>.success(givenJSON)
        
        service.obtainCurrencies(for: "EUR") { (result) in
            switch result {
            case .success(_):
                serviceExpectation.fulfill()
                XCTFail()
            case .error(let error):
                guard case ServiceError.parseError = error else {
                    XCTFail()
                    return
                }
                XCTAssertTrue(Thread.current.isMainThread)
                serviceExpectation.fulfill()
            }
        }
        wait(for: [serviceExpectation], timeout: 5)
    }
}
