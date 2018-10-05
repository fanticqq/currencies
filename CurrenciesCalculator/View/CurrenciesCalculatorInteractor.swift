//
//  CurrenciesCalculatorInteractor.swift
//  CurrenciesCalculator
//
//  Created by i.zarubin on 05/10/2018.
//  Copyright © 2018 i.zarubin. All rights reserved.
//

import Foundation

final class CurrenciesCalculatorInteractor {
	weak var output: CurrenciesCalculatorInteractorOutput?
    private let service: CurrenciesService
    private let sampler: Sampler

    init(service: CurrenciesService, sampler: Sampler) {
        self.service = service
        self.sampler = sampler
    }

    convenience init() {
        self.init(service: CurrenciesService(), sampler: Sampler(limit: 1, queue: .main))
    }
}

extension CurrenciesCalculatorInteractor: CurrenciesCalculatorInteractorInput {
    func obtainCurrencies(for currency: Currency) {
        sampler.invalidate()
        service.obtainCurrencies(for: currency.name) { [weak output] (result) in
            switch result {
            case .success(let currencies):
                output?.didReceive(currencies: currencies)
            case .error(let error):
                output?.didReceive(error: error)
            }
        }
    }
    
    func scheduleObtaining(for currency: Currency) {
        sampler.execute { [weak self] in
            self?.service.obtainCurrencies(for: currency.name) { (result) in
                switch result {
                case .success(let currencies):
                    self?.output?.didReceive(currencies: currencies)
                case .error(let error):
                    self?.output?.didReceive(error: error)
                }
            }
        }
    }
}
