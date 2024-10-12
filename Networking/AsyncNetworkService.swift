//
//  AsyncNetworkService.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

import Foundation

public final class AsyncNetworkService: URLRequestPerforming {
  private let session: NetworkSession

  init(
    session: NetworkSession
  ) {
    self.session = session
  }

  public func perform<Model: Decodable>(
    _ request: Request<Model>
  ) async -> Result<Model, URLSession.HTTPError> {
    let (result, _) = await performWithHeaders(request)
    return result
  }

  public func performWithHeaders<Model: Decodable>(
    _ request: Request<Model>
  ) async -> (Result<Model, URLSession.HTTPError>, [String: String]?) {
    #if PREVIEW
    if Constants.disableInternetForUITests { return (.failure(.transport(URLError(.notConnectedToInternet))), nil) }
    #endif

    let buildURLRequestResult = await request.buildURLRequest()
    let encodedRequest: URLRequest

    switch buildURLRequestResult {
    case let .failure(error):
      return (.failure(error), nil)

    case let .success(request):
      encodedRequest = request
    }

    do {
      let dataResponse = try await session.fetch(request: encodedRequest)
      switch dataResponse.statusCode {
      case 200..<300:
        switch await request.decodingStrategy(dataResponse.data) {
        case let .success(decodedMessage):
          return (.success(decodedMessage), dataResponse.headers)

        case let .failure(decodingError):
          let networkError = NetworkError.decoding(reason: decodingError.localizedDescription)
          return (.failure(.clientSide(networkError)), dataResponse.headers)
        }

      case 400:
        let error = URLSession.HTTPError(statusCode: dataResponse.statusCode)
        return (.failure(error), dataResponse.headers)

      case 401:
        let authError = URLSession.HTTPError(statusCode: dataResponse.statusCode)
        return (.failure(authError), dataResponse.headers)


      default:
        let payload = try? JSONSerialization.jsonObject(with: dataResponse.data) as? [String: Any]
        let error = URLSession.HTTPError(statusCode: dataResponse.statusCode, payload: payload)
        return (.failure(error), dataResponse.headers)
      }
    } catch {
      return (.failure(URLSession.HTTPError(error)), nil)
    }
  }
}

private extension URLSession.HTTPError {
  init(statusCode: Int, payload: [String: Any]? = nil) {
    self = .serverSide(ServerSideModel(
      statusCode: StatusCode(rawValue: statusCode),
      payload: payload
    ))
  }

  init(_ error: Error) {
    self = .transport(error as? URLError ?? URLError(.unknown))
  }
}
