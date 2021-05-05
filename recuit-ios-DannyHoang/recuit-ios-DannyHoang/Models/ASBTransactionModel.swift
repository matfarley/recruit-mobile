//
//  ASBTransactionModel.swift
//  recuit-ios-DannyHoang
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
  let gst: Float?
}

extension ASBTransaction: Decodable {
  
  // MARK:- ENUM
  private enum ASBTransactionCodingKeys: String, CodingKey {
    case id = "id"
    case transactionDate = "transactionDate"
    case summary = "summary"
    case debit = "debit"
    case credit = "credit"
  }
  
  // MARK:- Life Cycle Functions
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
    
    if let _debit = debit, _debit != 0 {
      gst = (debit! * 3) / 23
    } else {
      gst = nil
    }
  }
  
  // MARK:- Public Functions
  func getDateString() -> String {
    guard let _transactionDate = transactionDate else { return "" }
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
    return dateformatter.string(from: _transactionDate)
  }
  
  func getAmountString() -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .currency
    numberFormatter.maximumFractionDigits = 2
    if let _debit = debit, _debit != 0 {
      return numberFormatter.string(for: debit) ?? ""
    } else if let _credit = credit, _credit != 0 {
      return numberFormatter.string(for: credit) ?? ""
    }
    return ""
  }
  
  func getGSTString() -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .currency
    numberFormatter.maximumFractionDigits = 2
    guard let result = numberFormatter.string(for: gst) else { return "" }
    return result
  }
  
}
