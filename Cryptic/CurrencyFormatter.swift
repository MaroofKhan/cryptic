//
//  CurrencyFormatter.swift
//  Cryptic
//
//  Created by Maroof Khan on 10/11/2017.
//  Copyright © 2017 Maroof Khan. All rights reserved.
//

import Foundation

enum Currency: String {
    case USD, GBP, EUR
    
    func format(from response: Response) -> String? {
        let formatter: NumberFormatter = .init()
        formatter.currencyCode = rawValue
        formatter.numberStyle = .currency
        
        let amount = getAmount(from: response.bpi)
        return formatter.string(from: .init(floatLiteral: amount))
    }
    
    func getAmount(from bpi: Response.BPI) -> Double {
        switch self {
        case .USD: return bpi.USD.rate_float
        case .GBP: return bpi.GBP.rate_float
        case .EUR: return bpi.EUR.rate_float
        }
    }
    
}
