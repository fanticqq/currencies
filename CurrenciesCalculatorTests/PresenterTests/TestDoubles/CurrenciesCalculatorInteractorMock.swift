//
//  CurrenciesCalculatorInteractorMock.swift
//  CurrenciesCalculatorTests
//
//  Created by Igor Zarubin on 06/10/2018.
//  Copyright © 2018 i.zarubin. All rights reserved.
//

import XCTest
@testable import CurrenciesCalculator

final class CurrenciesCalculatorInteractorMock: CurrenciesCalculatorInteractorInput {
    var output: CurrenciesCalculatorInteractorOutput?
    var expectedResult: Result<[Currency]>?
    
    func obtainCurrencies(for currency: Currency) {
        guard let result = expectedResult else {
            fatalError("Result must be specified")
        }
        switch result {
        case .success(let currencies):
            output?.didReceive(currencies: currencies)
        case .error(let error):
            output?.didReceive(error: error)
        }
    }
    
    func scheduleObtaining(for currency: Currency) {
        
    }
    
    private func obtainCurrencies() {
        let currencies = EntityProvider.currencies()
        output?.didReceive(currencies: currencies)
    }
}
