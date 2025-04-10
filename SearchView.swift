//
//  SearchView.swift
//  ZesulE
//
//  Created by 시모니 on 4/7/25.


import SwiftUI

struct SearchView: View {
    
    @StateObject private var viewModel = SearchVM()
    @State private var address: String = ""
    @Binding var selectedLatitude: Double?
    @Binding var selectedLongitude: Double?
    @Binding var isNavigating: Bool
    @Binding var shouldFollowUser: Bool
    
    var body: some View {
        VStack {
            HStack {
                TextField("장소 , 주소 검색", text: $address)
                    .padding(.horizontal, 10)
                    .frame(height: 40)
                    .background(Color.white)
                    .cornerRadius(10)
                
                Button(action: {
                    viewModel.fetchSearchResults(for: address)
                }) {
                    Text("검색")
                        .frame(width: 60, height: 40)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 10)
                }
            }
            .padding()
            
            List(viewModel.suggestions) { result in
                VStack(alignment: .leading) {
                    Text(result.title)
                        .font(.headline)
                }
                .onTapGesture {
                    if let lat = result.latitude, let lng = result.longitude {
                        selectedLatitude = lat
                        selectedLongitude = lng
                        print("선택한 위치: 위도 \(lat), 경도 \(lng)")
                        shouldFollowUser = false
                        isNavigating = false  // ✅ 여기서 뒤로 가기
                    }
                }
            }
        }
        .background(Color(.systemGray6))
    }
    
}

