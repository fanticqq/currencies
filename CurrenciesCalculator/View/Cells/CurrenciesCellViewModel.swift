//
//  CurrenciesCellViewModel.swift
//  CurrenciesCalculator
//
//  Created by i.zarubin on 05/10/2018.
//  Copyright © 2018 i.zarubin. All rights reserved.
//

import UIKit

final class CurrenciesCellViewModel {
    let title: String
    var editing: Bool = false
    var value: String
    var onChangeText: ((CurrenciesCellViewModel, String) -> Void)?
    var onSelectCurrency: ((CurrenciesCellViewModel, Int) -> Void)?

    init(title: String, value: String) {
        self.title = title
        self.value = value
    }
}
