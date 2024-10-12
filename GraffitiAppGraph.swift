//
//  GraffitiAppGraph.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

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
