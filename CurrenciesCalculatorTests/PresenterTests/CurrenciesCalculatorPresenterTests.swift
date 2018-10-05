//
//  CurrenciesCalculatorPresenterTests.swift
//  CurrenciesCalculatorTests
//
//  Created by Igor Zarubin on 06/10/2018.
//  Copyright © 2018 i.zarubin. All rights reserved.
//

import XCTest
@testable import CurrenciesCalculator

class CurrenciesCalculatorPresenterTests: XCTestCase {
    var presenter: CurrenciesCalculatorPresenter!
    var interactor: CurrenciesCalculatorInteractorMock!
    var view: CurrenciesCalculatorViewStub!

    override func setUp() {
        let currency = Currency(name: "EUR", multiplier: 1)
        interactor = CurrenciesCalculatorInteractorMock()
        view = CurrenciesCalculatorViewStub()
        presenter = CurrenciesCalculatorPresenter(selectedCurrency: currency, interactor: interactor)
        
        presenter.view = view
        interactor.output = presenter
        view.output = presenter
    }

    override func tearDown() {
        view = nil
        presenter = nil
        interactor = nil
    }

    func testThatPresenterObtainsDataSucessfullyAndPassIntoView() {
        interactor.expectedResult = Result<[Currency]>.success(EntityProvider.currencies())
        
        XCTAssertFalse(view.loading)
        XCTAssertTrue(view.data.isEmpty)
        view.loadView()
        XCTAssertTrue(view.loading)
        XCTAssertFalse(view.data.isEmpty)
    }
    
    func testThatPresenterShowsAnError() {
        interactor.expectedResult = Result<[Currency]>.error(ServiceError.parseError)
        
        XCTAssertFalse(view.loading)
        XCTAssertTrue(view.data.isEmpty)
        view.loadView()
        XCTAssertTrue(view.loading)
        XCTAssertTrue(view.data.isEmpty)
        
        XCTAssertNotNil(view.error)
    }
}
