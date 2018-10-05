//
//  CurrenciesService.swift
//  CurrenciesCalculator
//
//  Created by i.zarubin on 05/10/2018.
//  Copyright © 2018 i.zarubin. All rights reserved.
//

import Foundation

protocol CurrenciesServiceProtocol {
    func obtainCurrencies(for base: String, completion: @escaping ((Result<[Currency]>) -> Void))
}

final class CurrenciesService: CurrenciesServiceProtocol {
    private let networkClient: NetworkClient

    enum ServiceError: Error {
        case parseError
    }

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    convenience init() {
        self.init(networkClient: NetworkClient())
    }

    func obtainCurrencies(for base: String, completion: @escaping ((Result<[Currency]>) -> Void)) {
        let task = networkClient.obtainData(from: .currencies(base: base)) { (result: Result<[String: Any]>) in

            switch result {
            case .success(let dict):
                guard let rates = dict["rates"] as? [String: Double] else {
                    completion(.error(ServiceError.parseError))
                    return
                }
                let currencies = rates.map({ (key, value) -> Currency in
                    return Currency(name: key, multiplier: value)
                }).sorted(by: { (lhs, rhs) -> Bool in
                    return lhs.name < rhs.name
                })
                DispatchQueue.main.async {
                    completion(.success(currencies))
                }
            case .error(let error):
                DispatchQueue.main.async {
                    completion(.error(error))
                }
            }
        }
        task.start()
    }
}
