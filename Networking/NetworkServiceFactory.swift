//
//  NetworkServiceFactory.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

import Foundation

public final class NetworkServiceFactory {
  public lazy var foregroundNetworkService = makeNetworkService(
    configuration: .default
      .withoutCache()
      .withDefaultTimeout(),
    makeTaskFactory: dataTask
  )

//  public lazy var backgroundNetworkService = makeNetworkService(
//    configuration: .background(withIdentifier: "me.scvairy.graffiti.background"),
//    makeTaskFactory: downloadTask
//  )

  public init() {}

  private func makeNetworkService(
    configuration: URLSessionConfiguration,
    makeTaskFactory: @escaping (URLSession) -> ((URLRequest) -> URLSessionTask)
  ) -> URLRequestPerforming {
    let sessionFacade = URLSessionFacade()

    sessionFacade.makeTask = makeTaskFactory(
      URLSession(
        configuration: configuration,
        delegate: sessionFacade,
        delegateQueue: nil
      )
    )

    return AsyncNetworkService(
      session: sessionFacade
    )
  }
}

// MARK: - Builders

private extension URLSessionConfiguration {
  func withoutCache() -> URLSessionConfiguration {
    requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    urlCache = nil
    return self
  }

  func withDefaultTimeout() -> URLSessionConfiguration {
    waitsForConnectivity = false
    timeoutIntervalForResource = 60.0
    return self
  }
}

private func dataTask(_ session: URLSession) -> (URLRequest) -> URLSessionTask {
  session.dataTask
}

private func downloadTask(_ session: URLSession) -> (URLRequest) -> URLSessionTask {
  session.downloadTask
}
