//
//  PixabayNetworkService.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

import Foundation
import SCNetwork

final actor PixabayNetworkService: ObservableObject, Sendable {
  private let requestFactory: URLRequestFactory
  private let networkService: URLRequestPerforming

  init(
    requestFactory: URLRequestFactory,
    networkService: URLRequestPerforming
  ) {
    self.requestFactory = requestFactory
    self.networkService = networkService
  }

  func fetchImages(
    query: String,
    page: Int = 1
  ) async -> Result<[(ImageModel, ImageModel)], Error> {
    let request = requestFactory.listImages(
      SearchImagesRequest(
        q: query,
        page: page
      )
    )
    let requestGraffiti = requestFactory.listImages(SearchImagesRequest(q: query + " graffiti"))
    let response = await networkService.perform(request)
    let responseGraffiti = await networkService.perform(requestGraffiti)
    switch (response, responseGraffiti) {
    case let (.success(response), .success(responseGraffiti)):
      return .success(Array(response.hits.zip(responseGraffiti.hits)))

    case let (.failure(error), _),
      let (_, .failure(error)):
      return .failure(error)
    }
  }
}
