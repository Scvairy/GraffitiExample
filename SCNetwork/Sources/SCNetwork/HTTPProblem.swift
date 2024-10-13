//
//  HTTPProblem.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

import Foundation

public extension URLSession {
  /// Хэлпер, который не является ошибкой - сообщает о роде проблем соединения
  /// Можно использовать, когда нужен факт, что это ошибка соединения
  enum HTTPProblem {
    case server
    case connection

    public var hasConnection: Bool {
      switch self {
      case .server:
        true
      case .connection:
        false
      }
    }
  }
}
