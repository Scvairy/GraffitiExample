//
//  Array+zip.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

public extension Array {
  func zip<T>(_ other: [T]) -> Zip2Sequence<[Element], [T]> {
    return Swift.zip(self, other)
  }
}
