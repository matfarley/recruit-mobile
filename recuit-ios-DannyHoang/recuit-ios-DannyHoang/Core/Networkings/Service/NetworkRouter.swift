//
//  NetworkRouter.swift
//  recuit-ios-mobile
//
//  Created by Danny Hoang on 05/05/21.
//  Copyright © 2021 Danny Hoang. All rights reserved.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()

protocol NetworkRouter: AnyObject {
  associatedtype EndPoint: EndPointType
  func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
  func cancel()
}

protocol EndPointType {
  var baseURL: URL { get }
  var path: String { get }
  var httpMethod: HTTPMethod { get }
  var task: HTTPTask { get }
  var headers: HTTPHeaders? { get }
}

public enum HTTPMethod : String {
  case get        = "GET"
  case post       = "POST"
  case put        = "PUT"
  case patch      = "PATCH"
  case delete     = "DELETE"
}

public typealias HTTPHeaders = [String: String]

public enum HTTPTask {
  case request
  case requestParameters(bodyParameters: Parameters?, urlParameters: Parameters?)
  case requestParameterAndHeaders(bodyParameters: Parameters?, urlParameters: Parameters?, additionHeaders: HTTPHeaders?)
}

public enum NetworkError: String, Error {
  case parametersNil = "Parameters were nil."
  case encodingFailed = "Parameter encoding failed."
  case missingURL = "URL is nil."
}
