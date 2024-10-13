//
//  CompletedDataResponse.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

import Foundation

struct CompletedDataResponse {
  private let response: HTTPURLResponse
  let data: Data

  init(response: HTTPURLResponse, data: Data) {
    self.response = response
    self.data = data
  }

  var statusCode: Int {
    response.statusCode
  }

  var headers: [String: String]? {
    response.allHeaderFields as? [String: String]
  }
}
