//
//  ParameterEncoding.swift
//  recuit-ios-DannyHoang
//
//  Created by Danny Hoang on 05/05/21.
//  Copyright © 2021 Danny Hoang. All rights reserved.
//

import Foundation

public typealias Parameters = [String:Any]

public protocol ParameterEncoder {
  static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

