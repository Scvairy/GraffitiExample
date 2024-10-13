//
//  ParametersTypes.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

import Foundation

extension SearchImagesRequest {
  enum ImageType: String {
    case all, photo, illustration, vector
  }

  enum Orientation: String {
    case all, horizontal, vertical
  }

  enum Category: String {
    case backgrounds, fashion, nature, science, education, feelings, health, people, religion, places, animals, industry, computer, food, sports, transportation, travel, buildings, business, music
  }

  enum Order: String {
    case popular, latest
  }

  enum Language: String {
    case cs, da, de, en, es, fr, id, it, hu, nl, no, pl, pt, ro, sk, fi, sv, tr, vi, th, bg, ru, el, ja, ko, zh
  }

  enum ColorFilter: String {
    case grayscale, transparent, red, orange, yellow, green, turquoise, blue, lilac, pink, white, gray, black, brown
  }
}
