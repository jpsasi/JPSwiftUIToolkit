//
//  JPMarquee.swift
//
//
//  Created by Sasikumar JP on 6/16/24.
//

import SwiftUI

public struct JPMarquee: View {
  @Binding var text: String
  @State private var displayText: String = ""
  @State private var containerSize: CGSize = .zero
  @State private var offset: CGFloat = 0.0
  @State private var textSize: CGSize = .zero
  @State private var originalTextSize: CGSize = .zero
  @State private var shouldAnimate: Bool = false
  @State private var id: Int = 0
  
  //View Modifier Properties
  var padding: EdgeInsets = .init()
  var font: Font = .callout
  var foregoundStyle: AnyShapeStyle = AnyShapeStyle(Color.primary)
  
  public init(text: Binding<String>) {
    self._text = text
  }
  
  public var body: some View {
    VStack {
      ScrollView(.horizontal) {
        Text(displayText)
          .font(font)
          .foregroundStyle(foregoundStyle)
          .offset(x: offset)
          .padding(padding)
          .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
              originalTextSize = textSize(text: self.text)
              if originalTextSize.width >= containerSize.width {
                self.displayText = self.text + Array(repeating: " ", count: 30)
                textSize = textSize(text: self.displayText)
                self.displayText = self.displayText + self.text
                shouldAnimate = true
                animate()
              } else {
                self.displayText = self.text
              }
            }
          }
          .onChange(of: text, {
            offset = 0
            id += 1
          })
          .onReceive(
            Timer
              .publish(
                every: (0.02 * textSize.width) + 3.0,
                on: .main,
                in: .default
              ).autoconnect()) { _ in
                offset = 0
                if shouldAnimate {
                  animate()
                }
              }
      }
      .background(
        GeometryReader { scrollViewProxy in
          Color.clear
            .onAppear {
              containerSize = scrollViewProxy.size
            }
        }
      )
    }
    .id(id)
  }
  
  private func animate() {
    offset = 0
    let duration = 0.02 * textSize.width
    withAnimation(.linear(duration: duration)) {
      offset = -textSize.width
    }
  }
  
  private func textSize(text: String) -> CGSize {
    guard let font = UIFont.from(font: font) else {
      print("Font is nil")
      return .zero
    }
    let attributes = [NSAttributedString.Key.font: font]
    return (text as NSString).size(withAttributes: attributes)
  }
}

//MARK: ViewModifier implementations
public extension JPMarquee {
  func padding(_ insets: EdgeInsets = .init()) -> JPMarquee {
    var copy = self
    copy.padding = insets
    return copy
  }
  
  func font(_ font: Font) -> JPMarquee {
    var copy = self
    copy.font = font
    return copy
  }
  
  func foregroundStyle(_ style: ForegroundStyle) -> JPMarquee {
    var copy = self
    copy.foregoundStyle = foregoundStyle
    return copy
  }
}

fileprivate extension UIFont {
  static func from(font: Font) -> UIFont? {
    switch font {
    case .largeTitle:
      return UIFont.preferredFont(forTextStyle: .largeTitle)
    case .subheadline:
      return UIFont.preferredFont(forTextStyle: .subheadline)
    case .title:
      return UIFont.preferredFont(forTextStyle: .title1)
    case .title2:
      return UIFont.preferredFont(forTextStyle: .title2)
    case .title3:
      return UIFont.preferredFont(forTextStyle: .title3)
    case .headline:
      return UIFont.preferredFont(forTextStyle: .headline)
    case .body:
      return UIFont.preferredFont(forTextStyle: .body)
    case .caption:
      return UIFont.preferredFont(forTextStyle: .caption1)
    case .caption2:
      return UIFont.preferredFont(forTextStyle: .caption2)
    case .footnote:
      return UIFont.preferredFont(forTextStyle: .footnote)
    case .callout:
      return UIFont.preferredFont(forTextStyle: .callout)
    default:
      return nil
    }
  }
}

#Preview {
  @Previewable @State var text = "Testing SwiftUI Marquee Text. I am testing and scrolling behaviour"
  VStack {
    JPMarquee(text: $text)
      .font(.headline)
    Button {
      text += ">"
    } label: {
      Text("Update")
    }
    
    Button {
      text.removeLast()
    } label: {
      Text("Remove")
    }
  }
}
