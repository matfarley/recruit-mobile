//
//  NetworkManager.swift
//  recuit-ios-DannyHoang
//
//  Created by Danny Hoang on 05/05/21.
//  Copyright © 2021 Danny Hoang. All rights reserved.
//

import Foundation

enum NetworkResponse: String {
  case success
  case authenticationError = "You need to be authenticated first."
  case badRequest = "Bad reqeust"
  case outdated = "The url you requested is outdated."
  case failed = "Network request failed."
  case noData = "Response returned with no data to decode."
  case unableToDecode = "We could no decode the response."
}

enum Result<String> {
  case success
  case failure(String)
}

struct NetworkManager {
  
  private let ABSTransactionRouter = Router<ASBTransactionAPI>()
  
  fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
    switch response.statusCode {
    case 200...299: return .success;
    case 401...499: return .failure(NetworkResponse.authenticationError.rawValue);
    case 500...599: return .failure(NetworkResponse.badRequest.rawValue);
    case 600: return .failure(NetworkResponse.outdated.rawValue);
    default: return .failure(NetworkResponse.failed.rawValue);
    }
  }
  
  func getTransactions(_ completion: @escaping (_ getTransactionsRespomse: [ASBTransaction]?, _ data: Data?, _ error: String?) -> ()) {
    ABSTransactionRouter.request(.getTransactions) { (data, response, error) in
      if error != nil {
        completion(nil, nil, "Please check your network connection.");
      }
      
      guard let `response` = response as? HTTPURLResponse else { return; }
      let result = self.handleNetworkResponse(response);
      switch result {
      case .success:
        guard let responseData = data else { completion(nil, nil, NetworkResponse.noData.rawValue); return; }
        do {
          let _ = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers);
          let apiResponse = try JSONDecoder().decode([ASBTransaction].self, from: responseData);
          completion(apiResponse, data, nil);
        } catch {
          print(error);
          completion(nil, nil, NetworkResponse.unableToDecode.rawValue);
        }
        
      case .failure(let networkFailureError):
        completion(nil, nil, networkFailureError);
      }
    }
  }
}
