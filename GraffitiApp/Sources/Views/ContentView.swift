//
//  ContentView.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var networkService: PixabayNetworkService

  @State var lastSearchQuery: String = ""
  @State var searchText: String = ""
  @State var error: String? = nil
  @State var images: [(ImageModel, ImageModel)] = []
  @State var pagesLoaded: Int = 0
  @State var isRefreshing: Bool = false
  @State var isLoadingMore: Bool = false
  @FocusState var searchFocused: Bool

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack {
          if let error {
            Text(error)
              .foregroundStyle(.red)
          }
        }
        .padding()
        ForEach(images, id: \.0.id) {
          let (image, graffitiImage) = $0
          if let url = URL(string: image.previewURL),
             let graffitiURL = URL(string: graffitiImage.previewURL) {
            HStack {
              VStack {
                AsyncImage(url: url)
                Text(image.tags)
              }
              VStack {
                AsyncImage(url: graffitiURL)
                Text(graffitiImage.tags)
              }
            }
          }
        }
        if !images.isEmpty, !isRefreshing, !isLoadingMore {
          Button(action: { loadMore() }) { Text("Load more") }
            .onAppear {
              loadMore()
            }
        } else if isLoadingMore {
          ProgressView()
        }
      }
      .navigationTitle(lastSearchQuery)
      .searchable(
        text: $searchText,
        placement: .navigationBarDrawer(displayMode: .always),
        prompt: Text("Search for images")
      )
      .searchFocused($searchFocused)
      .onSubmit(of: .search) {
        refresh()
      }
      .refreshable {
        refresh(force: true)
      }
      .onAppear {
        searchFocused = true
      }
      .navigationBarTitleDisplayMode(.inline)
    }
  }

  private func refresh(force: Bool = false) {
    searchFocused = false
    if !force {
      guard !searchText.isEmpty else { return }
    }
    self.error = nil
    self.images = []
    self.isRefreshing = true
    Task {
      let query = force ? lastSearchQuery : searchText
      let result = await networkService.fetchImages(query: query)
      await MainActor.run {
        switch result {
        case let .success(images):
          self.images = images
          self.pagesLoaded = 1
          self.lastSearchQuery = query
        case let .failure(error):
          self.error = error.localizedDescription
          self.pagesLoaded = 0
        }
        self.isRefreshing = false
      }
    }
  }

  private func loadMore() {
    guard !lastSearchQuery.isEmpty else { return }
    isLoadingMore = true
    Task {
      try await Task.sleep(for: .seconds(3))
      let result = await networkService.fetchImages(
        query: searchText,
        page: pagesLoaded + 1
      )
      await MainActor.run {
        switch result {
        case let .success(images):
          self.images += images
          self.pagesLoaded += 1
        case let .failure(error):
          self.error = error.localizedDescription
        }

        isLoadingMore = false
      }
    }
  }
}

#Preview {
  ContentView(images: [])
}
