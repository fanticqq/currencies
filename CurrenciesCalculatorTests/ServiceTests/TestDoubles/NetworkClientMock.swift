//
//  NetworkClientMock.swift
//  CurrenciesCalculatorTests
//
//  Created by Igor Zarubin on 05/10/2018.
//  Copyright © 2018 i.zarubin. All rights reserved.
//

import Foundation
@testable import CurrenciesCalculator

final class NetworkClientMock: NetworkClientProtocol {
    var expectedResult: Result<[String: Any]>?
    
    func obtainData(from endpoint: Endpoint, completion: @escaping ((Result<[String: Any]>) -> Void)) {
        guard let result = expectedResult else {
            fatalError("Result must be specified")
        }
        completion(result)
    }
}
