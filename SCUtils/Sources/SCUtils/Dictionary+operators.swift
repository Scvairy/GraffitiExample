//
//  Dictionary+operators.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

import Foundation

public extension Dictionary {
  static func += (lhs: inout Dictionary, rhs: Dictionary) {
    lhs.merge(rhs) { _, new in new }
  }

  static func + (lhs: Dictionary, rhs: Dictionary) -> Dictionary {
    lhs.merging(rhs) { _, new in new }
  }
}
