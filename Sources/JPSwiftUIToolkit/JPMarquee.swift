//
//  JPMarquee.swift
//
//
//  Created by Sasikumar JP on 6/16/24.
//

import SwiftUI

public struct JPMarquee: View {
  @Binding var text: String
  @State private var textSize: CGSize = .zero
  @State private var offset: CGFloat = .zero
  
  let font: UIFont
  let animationSpeed: CGFloat
  private let delay: CGFloat = 0.5
  
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
  @Previewable @State var text = "This is test message to test Marquee"
  JPMarquee(text: $text, font: .systemFont(ofSize: 21), animationSpeed: 0.02)
    .padding(.horizontal)
}
