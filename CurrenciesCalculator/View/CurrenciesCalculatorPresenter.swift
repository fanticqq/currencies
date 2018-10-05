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
	private let interactor: CurrenciesCalculatorInteractorInput
    private var selectedCurrency: Currency
    private var inputValue: Double

    init(selectedCurrency: Currency, interactor: CurrenciesCalculatorInteractorInput) {
        self.interactor = interactor
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
        var models: [CurrencyCellViewModel] = [selectedModel]
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
    func makeModel(from currency: Currency) -> CurrencyCellViewModel {
        let model = CurrencyCellViewModel(title: currency.name, value: price(for: currency))
        model.onChangeText = { [weak self] (model, text) in
            guard let weakSelf = self else {
                return
            }
            weakSelf.processTextChanging(text, for: model)
        }
        model.onSelectCurrency = { [weak self] model, index in
            guard let weakSelf = self else {
                return
            }
            weakSelf.processCurrencySelection(at: index, for: model, currency: currency)
        }
        return model
    }
    
    func processTextChanging(_ text: String, for model: CurrencyCellViewModel) {
        let value = Double(text) ?? 0
        inputValue = value
        model.value = price(for: selectedCurrency)
        interactor.scheduleObtaining(for: selectedCurrency)
    }
    
    func processCurrencySelection(at index: Int, for model: CurrencyCellViewModel, currency: Currency) {
        guard let value = Double(model.value) else {
            return
        }
        model.editing = true
        let selectedCurrency = Currency(name: currency.name, multiplier: 1)
        self.selectedCurrency = selectedCurrency
        inputValue = value
        view?.moveCell(from: index, to: 0)
        interactor.obtainCurrencies(for: selectedCurrency)
    }
    
    func price(for currency: Currency) -> String {
        return String(format: "%.2f", currency.multiplier * self.inputValue)
    }
}
