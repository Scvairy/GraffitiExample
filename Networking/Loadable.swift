//
//  Loadable.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

import Foundation

public enum Loadable<Response, Request> {
  case inited
  case pending(Request)
  case loaded(Response)

  public var unwrapped: Response? {
    if case let .loaded(value) = self {
      value
    } else {
      nil
    }
  }

  public var unwrappedRequest: Request? {
    if case let .pending(value) = self {
      value
    } else {
      nil
    }
  }

  public var isPending: Bool {
    switch self {
    case .inited, .loaded: false
    case .pending: true
    }
  }

  public var isLoaded: Bool {
    switch self {
    case .inited, .pending: false
    case .loaded: true
    }
  }
}
