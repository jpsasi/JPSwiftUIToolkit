//
//  JPMarquee.swift
//
//
//  Created by Sasikumar JP on 6/16/24.
//

import SwiftUI

public struct JPMarquee: View {
  @State private var text: String
  @State private var textSize: CGSize = .zero
  @State private var offset: CGFloat = .zero
  
  private var font: UIFont
  private let animationSpeed: CGFloat
  private let delay: CGFloat = 0.5
  
  public init(text: String, animationSpeed: CGFloat = 0.02,
              font: UIFont = .systemFont(ofSize: 16.0)) {
    self.text = text
    self.animationSpeed = animationSpeed
    self.font = font
  }
  
  public var body: some View {
    ScrollView(.horizontal) {
      Text(text)
        .font(Font(font))
        .offset(x: offset)
    }
    .disabled(false)            // Disable the manual scrolling
    .scrollIndicators(.hidden)  //hide the scrolling indicators
    .onAppear {
      text.append(String(repeating: " ", count: 20))
      textSize = size()
      text.append(text)
      animate()
    }
    .onReceive(
      Timer.publish(
        every: animationSpeed * textSize.width + delay,
        on: .main,
        in: .default)
      .autoconnect()) { _ in
      offset = 0
      animate()
    }
  }
  
  func size() -> CGSize {
    let attributes = [NSAttributedString.Key.font : font]
    return (text as NSString).size(withAttributes: attributes)
  }
  
  func animate() {
    let timeInterval = animationSpeed * textSize.width
    withAnimation(.linear(duration: timeInterval)) {
      offset = -textSize.width
    }
  }
}

#Preview {
  JPMarquee(text: "This is test message to test Marquee", animationSpeed: 0.01)
    .padding(.horizontal)
}
