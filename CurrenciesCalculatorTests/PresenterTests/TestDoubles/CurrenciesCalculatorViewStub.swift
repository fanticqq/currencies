//
//  CurrenciesCalculatorViewStub.swift
//  CurrenciesCalculatorTests
//
//  Created by Igor Zarubin on 06/10/2018.
//  Copyright © 2018 i.zarubin. All rights reserved.
//

import Foundation
@testable import CurrenciesCalculator

final class CurrenciesCalculatorViewStub: CurrenciesCalculatorViewInput {
    var output: CurrenciesCalculatorViewOutput!
    var loading: Bool = false
    var error: Error?
    var data = [CurrencyCellViewModel]()
    
    func loadView() {
        output.didLoadView()
    }
    
    func display(loading: Bool) {
        self.loading = loading
    }
    
    func display(error: Error) {
        self.error = error
    }
    
    func display(data: [CurrencyCellViewModel]) {
        self.data = data
    }
    
    func moveCell(from oldIndex: Int, to newIndex: Int) {
    }
}
