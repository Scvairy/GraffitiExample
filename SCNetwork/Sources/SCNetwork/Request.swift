//
//  Request.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

import Foundation

public struct Request<Model: Decodable>: Sendable {
  public typealias DecodingStrategy = @Sendable (Data) async -> Result<Model, Error>
  public typealias EncodingStrategy = @Sendable (any Encodable) async -> Result<Data, Error>

  public let urlComponents: URLComponents
  public let bodyToEncode: (any Encodable & Sendable)?
  public let decodingStrategy: DecodingStrategy
  public let encodingStrategy: EncodingStrategy
  public let method: HTTPMethod
  public let headers: [HTTPHeader]
  public let cachePolicy: URLRequest.CachePolicy
  public let apiKey: String?
  public let timeout: TimeInterval

  init(
    urlComponents: URLComponents,
    bodyToEncode: (any Encodable & Sendable)?,
    decodingStrategy: @escaping DecodingStrategy,
    encodingStrategy: @escaping EncodingStrategy,
    method: HTTPMethod,
    headers: [HTTPHeader],
    cachePolicy: URLRequest.CachePolicy,
    apiKey: String?,
    timeout: TimeInterval
  ) {
    self.urlComponents = urlComponents
    self.bodyToEncode = bodyToEncode
    self.decodingStrategy = decodingStrategy
    self.encodingStrategy = encodingStrategy
    self.method = method
    self.headers = headers
    self.cachePolicy = cachePolicy
    self.apiKey = apiKey
    self.timeout = timeout
  }

  func buildURLRequest() async -> Result<URLRequest, URLSession.HTTPError> {
    var urlComponents = self.urlComponents
    if let apiKey {
      urlComponents.queryItems?.append(URLQueryItem(name: "key", value: apiKey))
    }

    guard let url = urlComponents.url else {
      return .failure(
        URLSession.HTTPError.clientSide(
          NetworkError.unbuildableRequest(reason: "Url build failed from components \(urlComponents)")
        )
      )
    }

    var request = URLRequest(
      url: url,
      cachePolicy: cachePolicy
    ).with { request in
      request.httpMethod = method.rawValue
      request.set(headers: headers)
      request.timeoutInterval = timeout
    }

    if let bodyToEncode {
      let result = await encodingStrategy(bodyToEncode)

      switch result {
      case let .success(data):
        request.httpBody = data
      case let .failure(error):
        return .failure(
          URLSession.HTTPError.clientSide(
            NetworkError.unbuildableRequest(reason: "Message encode failed with error \(error)")
          )
        )
      }
    }

    return .success(request)
  }
}
