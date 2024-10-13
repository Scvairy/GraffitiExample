//
//  PixabayNetworkRequests.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

import Foundation
import SCNetwork

extension URLRequestFactory {
  func listImages(_ parameters: SearchImagesRequest) -> Request<SearchImagesResponse> {
    assemble(path: "/api/", queryItems: parameters.toURLQueryItems())
  }
}
