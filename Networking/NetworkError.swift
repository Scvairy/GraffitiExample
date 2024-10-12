//
//  NetworkError.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

import Foundation

public enum NetworkError: Error {
  case unbuildableRequest(reason: String)
  case decoding(reason: String)
  case badRequest(Data)

  var localizedDescription: String {
    switch self {
    case let .unbuildableRequest(reason):
      "Unbuildable request - \(reason)"
    case let .decoding(reason):
      "Decoding - \(reason)"
    case let .badRequest(data):
      "Bad request - \(String(decoding: data, as: UTF8.self))"
    }
  }
}
