//
//  Router.swift
//  recuit-ios-DannyHoang
//
//  Created by Danny Hoang on 05/05/21.
//  Copyright © 2021 Danny Hoang. All rights reserved.
//

import Foundation

class Router<EndPoint: EndPointType>: NetworkRouter {
  private var task: URLSessionTask?
  
  func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
    let session = URLSession.shared
    do {
      let request = try self.buildRequest(from: route);
      NetworkLogger.log(request: request)
      task = session.dataTask(with: request, completionHandler: { (data, response, error) in
        completion(data, response, error)
      })
    } catch {
      completion(nil, nil, error);
    }
    self.task?.resume();
  }
  
  func cancel() {
    self.task?.cancel();
  }
  
  fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
    guard let headers = additionalHeaders else { return }
    for (key, value) in headers {
      request.setValue(value, forHTTPHeaderField: key);
    }
  }
  
  fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
    let requestURLString = route.baseURL.absoluteString + "/" + route.path;
    guard let requestURL = URL(string: requestURLString) else { throw NSError(domain: "Network Request", code: 0, userInfo: nil); }
    var request = URLRequest(url: requestURL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0);
    request.httpMethod = route.httpMethod.rawValue;
    
    do {
      switch route.task {
      case .request:
        request.setValue("application/json", forHTTPHeaderField: "Content-Type");
        
      case .requestParameters(let bodyParameters, let urlParameters):
        try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request);
        
      case .requestParameterAndHeaders(let bodyParameters, let urlParameters, let additionHeaders):
        self.addAdditionalHeaders(additionHeaders, request: &request)
        try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request);
      }
      return request;
    } catch {
      throw error;
    }
  }
  
  fileprivate func configureParameters(bodyParameters: Parameters?, urlParameters: Parameters?, request: inout URLRequest) throws {
    do {
      if let `bodyParameters` = bodyParameters {
        try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters);
      }
      if let `urlParameters` = urlParameters {
        try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters);
      }
    } catch {
      throw error;
    }
  }
}
