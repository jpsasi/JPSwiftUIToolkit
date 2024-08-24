//
//  JPAnimatedTabBar.swift
//  JPSwiftUIToolkit
//
//  Created by Sasikumar JP on 7/16/24.
//
import SwiftUI

public struct JPAnimatedTabBar<SelectionValue, Content>: View where SelectionValue: Hashable, Content: View {
  
  @State var selectedTab: SelectionValue
  let content: () -> Content
  
  init(selectedTab: SelectionValue, @ViewBuilder content: @escaping () -> Content) {
    self.selectedTab = selectedTab
    self.content = content
  }
  
  public var body: some View {
    TabView(selection: $selectedTab) {
      content()
    }
  }
  
}

public struct TabItem {
  let systemImage: String
  let title: String
}

struct _TabItem: Identifiable {
  let id = UUID()
  let tabItem: TabItem
  var isAnimating: Bool
}

#Preview {
  let selectedTab: Int = 4
  JPAnimatedTabBar(selectedTab: selectedTab) {
    Text("Hello")
    Text("Hello1")
    Text("Hello2")
    Text("Hello3")
  }
}
