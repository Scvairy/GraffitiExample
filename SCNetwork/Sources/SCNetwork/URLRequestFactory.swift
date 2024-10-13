//
//  URLRequestFactory.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

import Foundation

public final class URLRequestFactory: Sendable {
  private let networkProvider: ApiNetworkProvider
  private let apiKeyProvider: ApiKeyProvider

  public init(networkProvider: ApiNetworkProvider, apiKeyProvider: ApiKeyProvider) {
    self.networkProvider = networkProvider
    self.apiKeyProvider = apiKeyProvider
  }

  public func assemble<Model: Decodable>(
    path: String,
    method: HTTPMethod = .post,
    body: (any Encodable & Sendable)? = nil,
    overriddenHost: String? = nil,
    headers: [HTTPHeader] = [],
    queryItems: [URLQueryItem] = [],
    cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData,
    timeout: TimeInterval = 60
  ) -> Request<Model> {
    Request(
      urlComponents: URLComponents().with { builder in
        builder.scheme = networkProvider.apiScheme
        builder.host = overriddenHost ?? networkProvider.apiHost
        builder.path = path
        builder.port = networkProvider.apiPort
        builder.queryItems = queryItems + [.init(name: "key", value: apiKeyProvider.apiKey)]
      },
      bodyToEncode: body,
      decodingStrategy: decode,
      encodingStrategy: encode,
      method: method,
      headers: headers,
      cachePolicy: cachePolicy,
      apiKey: apiKeyProvider.apiKey,
      timeout: timeout
    )
  }

  func encode(message: any Encodable) async -> Result<Data, Error> {
    do {
      let encodedData: Data = try JSONEncoder().encode(message)
      return .success(encodedData)
    } catch let encodingError {
      return .failure(encodingError)
    }
  }

  func decode<Model: Decodable>(data: Data) async -> Result<Model, Error> {
    do {
      let decodedMessage: Model = try JSONDecoder().decode(Model.self, from: data)
      return .success(decodedMessage)
    } catch let decodingError {
      return .failure(decodingError)
    }
  }
}

private extension URLRequest {
  init?(
    method: HTTPMethod,
    path: String,
    scheme: String,
    host: String,
    port: Int?,
    headers: [HTTPHeader],
    queryItems: [URLQueryItem],
    cachePolicy: URLRequest.CachePolicy,
    timeout: TimeInterval
  ) {
    var components = URLComponents()
    components.scheme = scheme
    components.host = host
    components.path = path
    components.port = port
    components.queryItems = queryItems
    guard let url = components.url else {
      assertionFailure("Damn, bad URL! Path: \(path)")
      return nil
    }

    self = URLRequest(
      url: url,
      cachePolicy: cachePolicy
    )
    httpMethod = method.rawValue
    timeoutInterval = timeout
    set(headers: headers)
  }
}
