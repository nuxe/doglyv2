//
//  MainTabView.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 2/9/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("Breeds", systemImage: "list.bullet.circle.fill") {
                DogListView()
            }

            Tab("Details", systemImage: "star.fill") {
                DogDetailView()
            }
        }
    }
}

#Preview {
    MainTabView()
}
