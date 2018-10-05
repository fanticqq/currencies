//
//  NetworkClient.swift
//  CurrenciesCalculator
//
//  Created by i.zarubin on 05/10/2018.
//  Copyright © 2018 i.zarubin. All rights reserved.
//

import Foundation

class NetworkRequest {
    private let task: URLSessionTask

    init(task: URLSessionTask) {
        self.task = task
    }

    func start() {
        task.resume()
    }

    func cancel() {
        task.cancel()
    }
}

final class NetworkClient {
    func obtainData<T>(from endpoint: Endpoint, completion: @escaping ((Result<T>) -> Void)) -> NetworkRequest {
        let task = URLSession.shared.dataTask(with: endpoint.url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(Result<T>.error(error!))
                return
            }

            if let result = (try? JSONSerialization.jsonObject(with: data)) as? T {
                completion(Result<T>.success(result))
            }
        }
        return NetworkRequest(task: task)
    }

    enum Endpoint {
        private static let baseURL = "https://revolut.duckdns.org/"
        case currencies(base: String)

        var url: URL {
            let urlString: String
            switch self {
            case .currencies(let base):
                urlString = "latest?base=\(base)"
            }
            guard let url = URL(string: Endpoint.baseURL + urlString) else {
                fatalError("Unable to build url")
            }
            return url
        }
    }
}
