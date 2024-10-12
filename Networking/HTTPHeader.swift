//
//  HTTPHeader.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

import Foundation

public struct HTTPHeader {
  let key: String
  let value: String?

  public init(key: String, value: String?) {
    self.key = key
    self.value = value
  }
}

public extension URLRequest {
  mutating func insert(header: HTTPHeader) {
    setValue(header.value, forHTTPHeaderField: header.key)
  }

  mutating func set(headers: [HTTPHeader]) {
    headers.forEach { insert(header: $0) }
  }
}

public extension URLSessionConfiguration {
  func insert(header: HTTPHeader) {
    var headers = httpAdditionalHeaders ?? [AnyHashable: Any]()
    headers[header.key] = header.value
    httpAdditionalHeaders = headers
  }
}
