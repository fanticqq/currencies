//
//  CurrenciesCalculatorProtocols.swift
//  CurrenciesCalculator
//
//  Created by i.zarubin on 05/10/2018.
//  Copyright © 2018 i.zarubin. All rights reserved.
//

import Foundation

protocol CurrenciesCalculatorViewInput: AnyObject {
    func display(loading: Bool)
    func display(error: Error)
    func display(data: [CurrenciesCellViewModel])
    func moveCell(from oldIndex: Int, to newIndex: Int)
}

protocol CurrenciesCalculatorViewOutput: AnyObject {
    func didLoadView()
}

protocol CurrenciesCalculatorInteractorInput: AnyObject {
    func obtainCurrencies(for currency: Currency)
    func scheduleObtaining(for currency: Currency)
}

protocol CurrenciesCalculatorInteractorOutput: AnyObject {
    func didReceive(currencies: [Currency])
    func didReceive(error: Error)
}
