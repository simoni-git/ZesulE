//
//  MainTapView.swift
//  ZesulE
//
//  Created by 시모니 on 4/8/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Image(systemName: "archivebox.fill")
                    Text("지도")
                }

            ContactsView()
                .tabItem {
                    Image(systemName: "phone.bubble.fill.rtl")
                    Text("연락처")
                }
        }
    }
}
