//
//  ApiNetworkProvider.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

public protocol ApiNetworkProvider {
  var apiHost: String { get }
  var apiPort: Int? { get }
  var apiScheme: String { get }
}
