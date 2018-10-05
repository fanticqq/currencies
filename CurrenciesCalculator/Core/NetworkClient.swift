//
//  NetworkClient.swift
//  CurrenciesCalculator
//
//  Created by i.zarubin on 05/10/2018.
//  Copyright © 2018 i.zarubin. All rights reserved.
//

import Foundation

protocol NetworkClientProtocol {
    func obtainData(from endpoint: Endpoint, completion: @escaping ((Result<[String: Any]>) -> Void))
}

final class NetworkClient: NetworkClientProtocol {
    func obtainData(from endpoint: Endpoint, completion: @escaping ((Result<[String: Any]>) -> Void)) {
        let task = URLSession.shared.dataTask(with: endpoint.url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.error(error!))
                return
            }

            if let result = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] {
                completion(.success(result))
            }
        }
        task.resume()
    }
}
