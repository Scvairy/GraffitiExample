//
//  URLRequestPerforming.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

import Foundation

public protocol URLRequestPerforming: AnyObject, Sendable {
  func perform<Model: Decodable>(_ request: Request<Model>) async -> Result<Model, URLSession.HTTPError>

  func performWithHeaders<Model: Decodable>(
    _ request: Request<Model>
  ) async -> (Result<Model, URLSession.HTTPError>, [String: String]?)
}
