//
//  NetworkSession.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

import Foundation

protocol NetworkSession: Sendable {
  func fetch(request: URLRequest) async throws -> CompletedDataResponse
}
