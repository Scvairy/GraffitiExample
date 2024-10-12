//
//  SearchImagesResponse.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

import Foundation

struct SearchImagesResponse: Decodable {
  let total: Int
  let totalHits: Int
  let hits: [ImageModel]
}

struct ImageModel: Decodable, Identifiable {
  let id: Int
  //    let pageURL: String
  let previewURL: String
  let tags: String
  //    let previewWidth: Int
  //    let previewHeight: Int
  //    let webformatURL: String
  //    let webformatWidth: Int
  //    let webformatHeight: Int
  //    let largeImageURL: String
  //    let views: Int
  //    let downloads: Int
  //    let likes: Int
  //    let comments: Int
  //    let user_id: Int
  //    let user: String
  //    let userImageURL: String
}
