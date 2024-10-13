//
//  GraffitiExampleApp.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

import SwiftUI

@main
struct GraffitiExampleApp: App {
  let graph = GraffitiAppGraph()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(graph.pixabayNetworkService)
    }
  }
}
