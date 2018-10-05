//
//  CurrencyCellViewModel.swift
//  CurrenciesCalculator
//
//  Created by i.zarubin on 05/10/2018.
//  Copyright © 2018 i.zarubin. All rights reserved.
//

import UIKit

final class CurrencyCellViewModel {
    let title: String
    var editing: Bool = false
    var value: String
    var onChangeText: ((CurrencyCellViewModel, String) -> Void)?
    var onSelectCurrency: ((CurrencyCellViewModel, Int) -> Void)?

    init(title: String, value: String) {
        self.title = title
        self.value = value
    }
}
