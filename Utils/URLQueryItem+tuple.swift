//
//  URLQueryItem+tuple.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

import Foundation

public extension URLQueryItem {
  init(tuple: (String, String?)) {
    self.init(name: tuple.0, value: tuple.1)
  }
}
