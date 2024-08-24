//
//  JPAsyncCacheImage.swift
//
//
//  Created by Sasikumar JP on 6/15/24.
//

import SwiftUI
import JPSwiftToolkit

@MainActor public var ImageCache: JPCache<URL, Image> = JPCache()

public struct JPAsyncCacheImage<Content>: View where Content: View {
  let url: URL
  let scale: CGFloat
  let transaction: Transaction
  let content: (AsyncImagePhase) -> Content

  public init(url: URL, scale: CGFloat = 1.0,
       transaction: Transaction = .init(animation: .easeIn),
       @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
    self.url = url
    self.scale = scale
    self.transaction = transaction
    self.content = content
  }
  
  public var body: some View {
    if let image = ImageCache.value(forKey: url) {
      content(.success(image))
    } else {
      AsyncImage(url: url) { phase in
        cacheAndRender(phase: phase)
      }
    }
  }
  
  private func cacheAndRender(phase: AsyncImagePhase) -> some View {
    if case let .success(image) = phase {
      ImageCache.insert(image, forKey: url)
    }
    return content(phase)
  }
}

#Preview {
  JPAsyncCacheImage(url: URL(string: "https://picsum.photos/4400/4900" )!, scale: 1.0, transaction: .init(animation: .easeIn)) { phase in
    if case let .success(image) = phase {
      image
        .resizable()
        .aspectRatio(contentMode: .fill)
        .ignoresSafeArea()
    } else if case .failure(let error) = phase {
      Image(systemName: "exclamationmark.triangle")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .ignoresSafeArea()
    } else {
      ProgressView()
    }
  }
}
