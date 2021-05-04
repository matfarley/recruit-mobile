//
//  MultipleBindingValue.swift
//  recuit-ios-mobile
//
//  Created by Truong Dinh Hoang on 5/05/21.
//

import Foundation

class MultipleBindingValue<T> {
  /**
   Typea aleas for property listeners
   
   */
  public typealias BindingListener = (T)->Void
  
  
  //- MARK: private vars
  
  fileprivate var listeners: [AnyHashable :BindingListener] = [AnyHashable :BindingListener]();
  
  
  //- MARK: Public interface
  
  public init(value: T){
    self.value = value
  }
  
  /**
   Binds the property listener and notifies immediately with the current value of the dynamic type
   
   - Parameters:
   - listener The property change listener
   */
  open func bindNotify(key: AnyHashable, _ listener: @escaping BindingListener){
    self.listeners[key] = listener;
    listener(value)
  }
  
  /**
   Binds the property listener.
   
   - Note: This method doesn't immediately notifies the binder of current property value.
   
   - Parameters:
   - listener The property change listener
   */
  
  open func bind(key: AnyHashable, _ listener: @escaping BindingListener) {
    self.listeners[key] = listener;
  }
  
  /**
   Remove listener.
   */
  open func remove(key: AnyHashable) {
    _ = self.listeners.removeValue(forKey: key);
  }
  
  
  /**
   Sends notification to trigger listener call without actual data change.
   */
  
  open func notify() {
    for (_, listener) in self.listeners {
      listener(value);
    }
  }
  
  //- MARK: Public properties
  
  open var value: T {
    didSet{
      for (_, listener) in self.listeners {
        listener(value);
      }
    }
  }
}

