//
//  ASBTransactionModel.swift
//  recuit-ios-mobile
//
//  Created by Truong Dinh Hoang on 5/05/21.
//

import Foundation

struct ASBTransaction {
  let id: String?
  let transactionDate: Date?
  let summary: String
  let debit: Float?
  let credit: Float?
}

extension ASBTransaction: Decodable {
  
  private enum ASBTransactionCodingKeys: String, CodingKey {
    case id = "id"
    case transactionDate = "transactionDate"
    case summary = "summary"
    case debit = "debit"
    case credit = "credit"
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: ASBTransactionCodingKeys.self)
    id = try container.decodeIfPresent(String.self, forKey: .id)
    if let transactionDateStr = try container.decodeIfPresent(String.self, forKey: .transactionDate) {
      transactionDate = DateFormatter.iso8601Full.date(from: transactionDateStr)
    } else {
      transactionDate = nil
    }
    summary = try container.decodeIfPresent(String.self, forKey: .summary) ?? ""
    debit = try container.decodeIfPresent(Float.self, forKey: .debit)
    credit = try container.decodeIfPresent(Float.self, forKey: .credit)
    
  }
  
  
  
}
