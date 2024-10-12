//
//  NSError+metadata.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

import Foundation

public extension NSError {
  var message: String {
    String(describing: self)
  }

  var metadata: [String: String] {
    userInfo.compactMapValues { value in
      if let stringValue = value as? String {
        stringValue
      } else if let stringConvertible = value as? CustomStringConvertible {
        stringConvertible.description
      } else {
        nil
      }
    } + [
      "domain": domain,
      "code": code.description,
    ]
  }
}
