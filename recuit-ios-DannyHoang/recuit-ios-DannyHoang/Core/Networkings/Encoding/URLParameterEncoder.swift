//
//  URLParameterEncoder.swift
//  recuit-ios-DannyHoang
//
//  Created by Danny Hoang on 05/05/21.
//  Copyright © 2021 Danny Hoang. All rights reserved.
//

import Foundation

public struct URLParameterEncoder: ParameterEncoder {
  public init() {
    
  }
  
  public static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
    guard let url = urlRequest.url else { throw NetworkError.missingURL }
    if let method = HTTPMethod(rawValue: urlRequest.httpMethod ?? "GET"), method == .get {
      if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
        urlComponents.queryItems = [URLQueryItem]();
        for (key, value) in parameters {
          let queryItem = URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed));
          urlComponents.queryItems?.append(queryItem);
        }
        urlRequest.url = urlComponents.url;
      }
    } else {
      urlRequest.httpBody = query(parameters).data(using: .utf8, allowLossyConversion: false)
    }
    
    //        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
    //            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
    //        }
  }
  
  public static func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
    var components: [(String, String)] = []
    
    if let dictionary = value as? [String: Any] {
      for (nestedKey, value) in dictionary {
        components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
      }
    } else if let array = value as? [Any] {
      for value in array {
        components += queryComponents(fromKey: "\(key)[]", value: value)
      }
    } else if let value = value as? NSNumber {
      if value.isBool {
        components.append((escape(key), escape((value.boolValue ? "1" : "0"))))
      } else {
        components.append((escape(key), escape("\(value)")))
      }
    } else if let bool = value as? Bool {
      components.append((escape(key), escape((bool ? "1" : "0"))))
    } else {
      components.append((escape(key), escape("\(value)")))
    }
    
    return components
  }
  
  private static func query(_ parameters: Parameters) -> String {
    var components: [(String, String)] = []
    
    for key in parameters.keys.sorted(by: <) {
      let value = parameters[key]!
      components += queryComponents(fromKey: key, value: value)
    }
    return components.map { "\($0)=\($1)" }.joined(separator: "&")
  }
  /// Returns a percent-escaped string following RFC 3986 for a query string key or value.
  ///
  /// RFC 3986 states that the following characters are "reserved" characters.
  ///
  /// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
  /// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
  ///
  /// In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
  /// query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
  /// should be percent-escaped in the query string.
  ///
  /// - parameter string: The string to be percent-escaped.
  ///
  /// - returns: The percent-escaped string.
  public static func escape(_ string: String) -> String {
    let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
    let subDelimitersToEncode = "!$&'()*+,;="
    
    var allowedCharacterSet = CharacterSet.urlQueryAllowed
    allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
    
    var escaped = ""
    
    if #available(iOS 8.3, *) {
      escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
    } else {
      let batchSize = 50
      var index = string.startIndex
      
      while index != string.endIndex {
        let startIndex = index
        let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) ?? string.endIndex
        let range = startIndex..<endIndex
        
        let substring = string[range]
        
        escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? String(substring)
        
        index = endIndex
      }
    }
    
    return escaped
  }
}


// MARK: -
extension NSNumber {
  fileprivate var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}
