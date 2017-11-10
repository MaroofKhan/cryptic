//
//  Rates.swift
//  Cryptic
//
//  Created by Maroof Khan on 10/11/2017.
//  Copyright © 2017 Maroof Khan. All rights reserved.
//

import Foundation

struct Response: Codable {
    struct BPI: Codable {
        struct Currency: Codable {
            let code: String
            let symbol: String
            let rate_float: Double
        }
        
        let USD: Currency
        let GBP: Currency
        let EUR: Currency
    }
    let bpi: BPI
}

struct Coinbase {
    static var bitcoin: Result<Response> {
        let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json")!
        let request = URLRequest(url: url)
        return .init(request: request)
    }
}

class Result<V: Codable> {
    
    typealias Success = (V) -> Void
    typealias Failure = (Error) -> Void
    
    private var response: Success?
    private var error: Failure?
    
    private let request: URLRequest
    
    init(request: URLRequest) {
        self.request = request
    }
    
    @discardableResult func success(_ success: @escaping Success) -> Result {
        response = success
        return self
    }
    
    @discardableResult func failure(_ failure: @escaping Failure) -> Result {
        error = failure
        return self
    }
    
    func execute() {
        let session: URLSession = .init(configuration: .default)
        let task = session.dataTask(with: request) { [weak self] (data, response, error) in
            
            guard let `self` = self else {
                assertionFailure("Oh God why?!")
                return
            }
            
            guard let data = data else {
                let damned = error ?? NSError(domain: "Domain", code: 1001, userInfo: [:]) as Error
                self.error?(damned)
                return
            }
            
            do {
                let decoder: JSONDecoder = .init()
                let value = try decoder.decode(V.self, from: data)
                self.response?(value)
            } catch {
                self.error?(error)
            }
        }
        
        task.resume()
    }
    
    
}
