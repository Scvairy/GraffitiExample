//
//  Error+nsError.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//
import Foundation

public extension Error {
  var nsError: NSError {
    self as NSError
  }
}
