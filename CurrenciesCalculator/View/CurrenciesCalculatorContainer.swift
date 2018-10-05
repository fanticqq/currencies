//
//  CurrenciesCalculatorContainer.swift
//  CurrenciesCalculator
//
//  Created by i.zarubin on 05/10/2018.
//  Copyright © 2018 i.zarubin. All rights reserved.
//

import UIKit

final class CurrenciesCalculatorContainer {

	class func assemble() -> UIViewController {
		let viewController = CurrenciesCalculatorViewController()
        let presenter = CurrenciesCalculatorPresenter(selectedCurrency: Currency(name: "EUR", multiplier: 1))
		let interactor = CurrenciesCalculatorInteractor()

		viewController.output =  presenter

		presenter.view = viewController
		presenter.interactor = interactor

		interactor.output = presenter

		return viewController
	}
}
