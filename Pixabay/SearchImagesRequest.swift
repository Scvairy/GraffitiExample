//
//  SearchImagesRequest.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

import Foundation

struct SearchImagesRequest {
  var q: String?
  var lang: Language = .en
  var id: String?
  var imageType: ImageType = .all
  var orientation: Orientation = .all
  var category: Category?
  var minWidth: Int = 0
  var minHeight: Int = 0
  var colors: [ColorFilter]?
  var editorsChoice: Bool = false
  var safeSearch: Bool = false
  var order: Order = .popular
  var page: Int = 1
  var perPage: Int = 10
  var callback: String?
  var pretty: Bool = false

  func toURLQueryItems() -> [URLQueryItem] {
    let queryParams: [(String, String?)] = [
      ("q", q),
      ("lang", lang.rawValue),
      ("id", id),
      ("image_type", imageType.rawValue),
      ("orientation", orientation.rawValue),
      ("category", category?.rawValue),
      ("min_width", minWidth > 0 ? "\(minWidth)" : nil),
      ("min_height", minHeight > 0 ? "\(minHeight)" : nil),
      ("colors", colors?.map { $0.rawValue }.joined(separator: ",")),
      ("editors_choice", editorsChoice ? "true" : nil),
      ("safesearch", safeSearch ? "true" : nil),
      ("order", order.rawValue),
      ("page", page > 1 ? "\(page)" : nil),
      ("per_page", perPage != 20 ? "\(perPage)" : nil),
      ("callback", callback),
      ("pretty", pretty ? "true" : nil)
    ]

    return queryParams.compactMap(URLQueryItem.init)
  }
}
