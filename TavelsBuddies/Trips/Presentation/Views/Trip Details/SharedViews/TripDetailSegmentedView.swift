//
//  TripDetailSegmentedView.swift
//  TavelsBuddies
//
//  Created by tarek on 03/10/2025.
//

import SwiftUI

struct SegmentedTab: Identifiable {
    let id = UUID()
    let title: String
    let view: AnyView
}

struct TripDetailSegmentedView: View {
    let tabs: [SegmentedTab]
    @State private var selectedTab = 0
    
    init(tabs: [SegmentedTab]) {
        self.tabs = tabs
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom Segmented Control
            Picker("", selection: $selectedTab) {
                ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                    Text(tab.title).tag(index)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .onAppear {
                UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.white
                UISegmentedControl.appearance().backgroundColor = UIColor.systemGray4.withAlphaComponent(0.1)
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.systemGray], for: .normal)
            }
            
            // Content Views
            TabView(selection: $selectedTab) {
                ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                    tab.view
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}


#Preview {
    TripDetailSegmentedView(tabs: [
        SegmentedTab(title: "Overview", view: AnyView(Text("hello"))),
        SegmentedTab(title: "Participants (4)", view: AnyView(Text("hello111")))
    ])
}
