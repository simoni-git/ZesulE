//
//  MainView.swift
//  ZesulE
//
//  Created by 시모니 on 4/7/25.
//

import SwiftUI
import NMapsMap

struct ContentView: View {
    
    @State var text: String = ""
    @StateObject private var viewModel = ContentVM()
    @State private var mapView = NMFMapView()
    @State private var currentCircle: NMFCircleOverlay?
    
    var body: some View {
        NavigationView {
            ZStack {
                NaverMapView(viewModel: viewModel
                             ,mapView: $mapView,
                             currentCircle: $currentCircle)
                VStack {
                    ZStack {
                        TextField("주소를 입력하세요.", text: $text)
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .textFieldStyle(.roundedBorder)
                        
                        Button(action: {
                            print("tap - TextFieldBtn")
                            viewModel.isNavigating = true
                        }) {
                            Color.clear
                        }
                        .frame(maxWidth: .infinity, maxHeight: 40)
                    }
                    
                    Spacer()
                    
                    InfoView(viewModel: viewModel, shouldFollowUser: $viewModel.shouldFollowUser , selectedInfo: viewModel.selectedInfo )
                }
                .padding()
                .onAppear {
                    viewModel.makeMarking()
                }
                
                NavigationLink(destination: SearchView(selectedLatitude: $viewModel.targetLat, selectedLongitude: $viewModel.targetLng,isNavigating: $viewModel.isNavigating , shouldFollowUser: $viewModel.shouldFollowUser), isActive: $viewModel.isNavigating) {
                    EmptyView()
                }
            }
        }
    }
    
}
