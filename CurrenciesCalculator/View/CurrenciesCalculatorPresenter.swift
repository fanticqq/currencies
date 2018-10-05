//
//  CurrenciesCalculatorPresenter.swift
//  CurrenciesCalculator
//
//  Created by i.zarubin on 05/10/2018.
//  Copyright © 2018 i.zarubin. All rights reserved.
//

import Foundation

final class CurrenciesCalculatorPresenter {
	weak var view: CurrenciesCalculatorViewInput?
	var interactor: CurrenciesCalculatorInteractorInput!
    private var selectedCurrency: Currency
    private var inputValue: Double

    init(selectedCurrency: Currency) {
        self.selectedCurrency = selectedCurrency
        self.inputValue = selectedCurrency.multiplier
    }
}

extension CurrenciesCalculatorPresenter: CurrenciesCalculatorViewOutput {
    func didLoadView() {
        interactor.obtainCurrencies(for: selectedCurrency)
        view?.display(loading: true)
    }
}

extension CurrenciesCalculatorPresenter: CurrenciesCalculatorInteractorOutput {
    func didReceive(currencies: [Currency]) {
        let selectedModel = makeModel(from: selectedCurrency)
        selectedModel.editing = true
        var models: [CurrenciesCellViewModel] = [selectedModel]
        models.append(contentsOf: currencies.map(makeModel(from:)))

        view?.display(data: models)
        view?.display(loading: false)
        
        interactor.scheduleObtaining(for: selectedCurrency)
    }

    func didReceive(error: Error) {
        view?.display(data: [])
        view?.display(error: error)
        view?.display(loading: false)
    }
}

private extension CurrenciesCalculatorPresenter {
    func makeModel(from currency: Currency) -> CurrenciesCellViewModel {
        let model = CurrenciesCellViewModel(title: currency.name, value: price(for: currency))
        model.onChangeText = { [weak self] (model, text) in
            guard let weakSelf = self else {
                return
            }
            let value = Double(text) ?? 0
            weakSelf.inputValue = value
            model.value = weakSelf.price(for: currency)
            weakSelf.interactor.scheduleObtaining(for: weakSelf.selectedCurrency)
        }
        model.onSelectCurrency = { [weak self] model, index in
            guard let weakSelf = self, let value = Double(model.value) else {
                return
            }
            let selectedCurrency = Currency(name: currency.name, multiplier: 1)
            model.editing = true
            weakSelf.selectedCurrency = selectedCurrency
            weakSelf.inputValue = value
            weakSelf.view?.moveCell(from: index, to: 0)
            weakSelf.interactor.obtainCurrencies(for: selectedCurrency)
        }
        return model
    }
    
    func price(for currency: Currency) -> String {
        return String(format: "%.2f", currency.multiplier * self.inputValue)
    }
}
