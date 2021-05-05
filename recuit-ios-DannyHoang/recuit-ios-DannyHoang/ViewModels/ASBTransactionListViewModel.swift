//
//  ASBTransactionListVM.swift
//  recuit-ios-DannyHoang
//
//  Created by Truong Dinh Hoang on 5/05/21.
//

import Foundation

class ASBTransactionListViewModel {
  //MARK: - Const
  let networkManager = NetworkManager()
  
  //MARK: - Public variables
  var transactionListResponse: [ASBTransaction]? = nil{
    didSet {
      transactionList.value = transactionListResponse
    }
  }
  
  var transactionList: MultipleBindingValue<[ASBTransaction]?> = MultipleBindingValue(value: nil)
  
  var fetchTransactionErrorMessage: MultipleBindingValue<String?> = MultipleBindingValue(value: nil)
  
  
  //MARK: - Public functions
  /**
    Function to fetch transacions
   
   */
  func fetchTransactionList() {
    networkManager.getTransactions {[weak self] transactionList, data, errorString in
      guard let strongSelf = self else { return }
      defer {
        strongSelf.fetchTransactionErrorMessage.value = errorString
      }
      
      guard errorString == nil else {
        strongSelf.transactionList.value = nil
        return
      }
      guard var result = transactionList else {
        strongSelf.transactionList.value = nil
        return
      }
      
      // Sort response array by transaction date with decending order.
      //
      result = result.sorted(by: {
        ($0.transactionDate ?? .distantPast) > ($1.transactionDate ?? .distantPast)
      })
      
      strongSelf.transactionListResponse = result
    }
  }
  
  /**
    Function to find transacions which contain a string
   
   - Parameters:
   - text The string want to search
   */
  func filterBySummary(_ text: String) {
    guard let _ = transactionListResponse else {
      transactionList.value = []
      return
    }
    transactionList.value = transactionListResponse?.filter({ $0.summary.contains(text) })
  }
}
