//
//  ASBTransactionAPI.swift
//  recuit-ios-DannyHoang
//
//  Created by Danny Hoang on 05/05/21.
//  Copyright © 2021 Dinh Hoang. All rights reserved.

import Foundation

public enum ASBTransactionAPI {
  case getTransactions
}

extension ASBTransactionAPI: EndPointType {
  var environmentBaseURL: String {
    return "https://60220907ae8f8700177dee68.mockapi.io/api/v1"
  }
  
  
  var baseURL: URL {
    guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
    return url
  }
  
  var path: String {
    switch self {
    case .getTransactions:
      return "transactions"
    }
  }
  
  var httpMethod: HTTPMethod {
    return .get
  }
  
  var task: HTTPTask {
    switch self {
    case .getTransactions:
      return .requestParameters(bodyParameters: nil, urlParameters: nil)
    }
  }
  
  var headers: HTTPHeaders? {
    return nil
  }
}
