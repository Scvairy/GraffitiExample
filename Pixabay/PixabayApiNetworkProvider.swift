//
//  PixabayApiNetworkProvider.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

struct PixabayApiNetworkProvider: ApiNetworkProvider {
  var apiHost: String { "pixabay.com" }
  var apiPort: Int? { nil }
  var apiScheme: String { "https" }
}
