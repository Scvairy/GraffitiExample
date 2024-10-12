//
//  HTTPProblem.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

import Foundation

public extension URLSession {
  enum HTTPError: Error {
    public struct ServerSideModel {
      public let statusCode: StatusCode
      public let payload: [String: Any]?

      init(
        statusCode: StatusCode,
        payload: [String: Any]? = nil
      ) {
        self.statusCode = statusCode
        self.payload = payload
      }
    }

    case transport(URLError)
    case serverSide(ServerSideModel)
    case clientSide(NetworkError)

    public var localizedDescription: String {
      switch self {
      case let .transport(error):
        "Траспортная ошибка \(error.errorCode): " + error.localizedDescription
      case let .serverSide(model):
        "Ошибка сервера с кодом: \(model.statusCode)"
      case let .clientSide(networkError):
        "Ошибка клиента:\n\(networkError.localizedDescription)"
      }
    }

    public var problem: HTTPProblem {
      switch self {
      case let .transport(transportError):
        switch transportError.code {
        case .notConnectedToInternet, .timedOut, .networkConnectionLost, .cannotConnectToHost:
          .connection
        default:
          .server
        }
      case .clientSide, .serverSide:
        switch metadata["code"] {
        case "-1009", "-1005", "-1004":
          .connection
        default:
          .server
        }
      }
    }
  }
}

extension URLSession.HTTPError {
  public var message: String {
    localizedDescription
  }

  public var metadata: [String: String] {
    underlyingError.nsError.metadata + ["localizedDescription": underlyingError.nsError.localizedDescription]
  }

  var underlyingError: Error {
    switch self {
    case let .transport(urlError):
      urlError
    default:
      self
    }
  }
}
