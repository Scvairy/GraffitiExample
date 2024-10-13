//
//  ApiKeyProvider.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

public protocol ApiKeyProvider: Sendable {
  var apiKey: String { get }
}
