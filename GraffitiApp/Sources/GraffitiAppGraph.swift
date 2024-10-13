//
//  GraffitiAppGraph.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

import SCNetwork

final class GraffitiAppGraph {
  let networkServiceFactory = NetworkServiceFactory()
  let requestFactory = URLRequestFactory(
    networkProvider: PixabayApiNetworkProvider(),
    apiKeyProvider: PixabayApiKeyProvider()
  )

  lazy var pixabayNetworkService = PixabayNetworkService(
    requestFactory: requestFactory,
    networkService: networkServiceFactory.foregroundNetworkService
  )
}
