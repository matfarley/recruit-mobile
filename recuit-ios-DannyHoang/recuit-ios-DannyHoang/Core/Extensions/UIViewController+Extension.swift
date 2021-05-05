//
//  UIViewController+Extension.swift
//  recuit-ios-DannyHoang
//
//  Created by Truong Dinh Hoang on 5/05/21.
//

import UIKit

extension UIViewController {
  func performInMainThread( block: @escaping () -> Void) {
    if (Thread.current.isMainThread) {
      block();
    } else {
      DispatchQueue.main.async { block(); }
    }
  }
}
