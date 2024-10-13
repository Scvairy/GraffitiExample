//
//  URLSessionFacade.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

import Foundation
import ThreadSafe

final class URLSessionFacade: NSObject, NetworkSession, Sendable {
  @ThreadSafe
  private var continuations: [URLSessionTask: DataContinuation] = [:]

  @ThreadSafe
  var makeTask: ((URLRequest) -> URLSessionTask)? = nil

  func fetch(request: URLRequest) async throws -> CompletedDataResponse {
    try await withCheckedThrowingContinuation { continuation in
      guard let makeTask else {
        assertionFailure("No injected makeTask closure in URLSessionFacade")
        return
      }
      let task = makeTask(request)
      continuations[task] = DataContinuation(continuation)
      task.resume()
    }
  }
}

extension URLSessionFacade: URLSessionDataDelegate {
  func urlSession(
    _ session: URLSession,
    dataTask: URLSessionDataTask,
    didReceive data: Data
  ) {
    guard continuations[dataTask] != nil else {
      assertionFailure("No continuation when receiving data in URLSessionDataDelegate")
      return
    }
    continuations[dataTask]?.append(data: data)
  }
}

extension URLSessionFacade: URLSessionDownloadDelegate {
  func urlSession(
    _ session: URLSession,
    downloadTask: URLSessionDownloadTask,
    didFinishDownloadingTo location: URL
  ) {
    guard continuations[downloadTask] != nil else {
      assertionFailure("No continuation when receiving data in URLSessionDownloadDelegate")
      return
    }

    guard let data = try? Data(contentsOf: location, options: .alwaysMapped) else {
      assertionFailure("Failed to decode data in URLSessionDownloadDelegate")
      return
    }

    continuations[downloadTask]?.append(data: data)
  }
}

extension URLSessionFacade: URLSessionDelegate {
  func urlSession(
    _ session: URLSession,
    task: URLSessionTask,
    didCompleteWithError error: (any Error)?
  ) {
    guard let continuation = continuations[task] else {
      assertionFailure("No continuation when completed request in URLSessionDelegate")
      return
    }

    if let error {
      continuation.onFailure(with: error)
      return
    }

    guard let httpResponse = task.response as? HTTPURLResponse else {
      continuation.onFailure(with: URLError(.badServerResponse))
      return
    }

    continuation.onSuccess(with: httpResponse)
    continuations[task] = nil
  }
}

private struct DataContinuation {
  private let continuation: CheckedContinuation<CompletedDataResponse, any Error>
  private var receivedData = Data()

  init(_ continuation: CheckedContinuation<CompletedDataResponse, any Error>) {
    self.continuation = continuation
  }

  mutating func append(data: Data) {
    receivedData.append(data)
  }

  func onSuccess(with response: HTTPURLResponse) {
    let dataResponse = CompletedDataResponse(
      response: response,
      data: receivedData
    )
    continuation.resume(returning: dataResponse)
  }

  func onFailure(with error: any Error) {
    continuation.resume(throwing: error)
  }
}
