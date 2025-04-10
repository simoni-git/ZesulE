//
//  InfoView.swift
//  ZesulE
//
//  Created by 시모니 on 4/7/25.
//

import SwiftUI

struct InfoView: View {
    
    @ObservedObject var viewModel: ContentVM
    @Binding var shouldFollowUser: Bool
    let selectedInfo: MarkerInfo?
    let cardWidth: CGFloat = UIScreen.main.bounds.width * 0.8
    let cardHeight: CGFloat = UIScreen.main.bounds.height * 0.2
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 0.0) {
            Spacer()
            
            Button {
                print("tap Button()")
                viewModel.shouldFollowUser = true
                
            } label: {
                Image(systemName: "safari.fill")
                    .font(.title)
                    .scaledToFit()
                    .foregroundColor(.orange)
                    .frame(width: 40, height: 40)
                
            }
            .frame(width: 40 , height: 40)
            .cornerRadius(10)
            
            Rectangle()
                .frame(width: cardWidth , height: cardHeight)
                .cornerRadius(25)
                .padding(.bottom , 10)
                .overlay(
                    VStack(alignment: .leading, spacing: 10) {
                        if let info = selectedInfo {
                            Text("📍상세주소: \(info.detlCn)")
                            Text("📍관리구청: \(info.mgcNm)청")
                            Text("📍제설함번호: \(info.sboxNum)")
                        } else {
                            Text("🟧 반경 500미터 입니다.")
                            Text("마커를 탭해주세요.")
                        }
                    }
                        .foregroundColor(.white)
                        .padding(.leading , 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                )
                .padding(.bottom, 10)
        }
    }
    
}

