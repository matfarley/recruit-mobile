//
//  ASBTransactionListVM.swift
//  recuit-ios-DannyHoang
//
//  Created by Truong Dinh Hoang on 5/05/21.
//

import Foundation

class ASBTransactionListViewModel {
  var transactionListResponse: [ASBTransaction]? = nil{
    didSet {
      transactionList.value = transactionListResponse
    }
  }
  var transactionList: MultipleBindingValue<[ASBTransaction]?> = MultipleBindingValue(value: nil)
  let networkManager = NetworkManager()
  
  func fetchTransactionList() {
    networkManager.getTransactions {[weak self] transactionList, data, errorString in
      guard let strongSelf = self else { return }
      guard errorString == nil else {
        strongSelf.transactionList.value = nil
        return
      }
      guard var result = transactionList else {
        strongSelf.transactionList.value = nil
        return
      }
      result = result.sorted(by: {
        ($0.transactionDate ?? .distantPast) > ($1.transactionDate ?? .distantPast)
      })
      strongSelf.transactionListResponse = result
    }
  }
  
  func filterBySummary(_ text: String) {
    guard let _ = transactionListResponse else {
      transactionList.value = []
      return
    }
    transactionList.value = transactionListResponse?.filter({ $0.summary.contains(text) })
  }
}
