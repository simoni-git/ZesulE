//
//  ContentVM.swift
//  ZesulE
//
//  Created by 시모니 on 4/7/25.
//

import Foundation
import Firebase
import NMapsMap

class ContentVM: ObservableObject {
    
    let db = Database.database().reference()
    var selectedMarker: NMFMarker?
    
    @Published var markers: [MarkerItem] = []
    @Published var selectedInfo: MarkerInfo? = nil
    @Published var isNavigating = false
    @Published var shouldFollowUser: Bool = true
    @Published var targetLat: Double? = nil
    @Published var targetLng: Double? = nil
    
    func makeMarking() {
        let db = Database.database().reference()
        db.child("DATA").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self,
                  let data = snapshot.value as? [[String: Any]] else {
                print("Firebase에서 데이터를 가져오지 못했어요")
                return
            }
            
            var newMarkerItems: [MarkerItem] = []
            
            for item in data {
                if let lat = item["lat"] as? Double,
                   let lng = item["lng"] as? Double,
                   let detlCn = item["detl_cn"] as? String,
                   let mgcNm = item["mgc_nm"] as? String,
                   let sboxNum = item["sbox_num"] as? String {
                    
                    let marker = NMFMarker()
                    marker.position = NMGLatLng(lat: lat, lng: lng)
                    marker.iconImage = NMF_MARKER_IMAGE_GREEN
                    
                    let info = MarkerInfo(lat: lat, lng: lng, detlCn: detlCn, mgcNm: mgcNm, sboxNum: sboxNum)
                    let markerItem = MarkerItem(marker: marker, info: info)
                    
                    // ✅ 마커 터치 시 동작 정의
                    marker.touchHandler = { [weak self] overlay in
                        guard let self = self else { return true }
                        self.shouldFollowUser = false
                        self.selectedMarker?.iconImage = NMF_MARKER_IMAGE_GREEN
                        marker.iconImage = NMF_MARKER_IMAGE_RED
                        self.selectedMarker = marker
                        self.selectedInfo = markerItem.info
                        
                        // 마커 정보 출력
                        print("디테일: \(info.detlCn), 이름: \(info.mgcNm), 박스 번호: \(info.sboxNum)")
                        
                        return true
                    }
                    
                    newMarkerItems.append(markerItem)
                }
            }
            
            DispatchQueue.main.async {
                self.markers = newMarkerItems
                print("총 마커 개수: \(self.markers.count)")
            }
        }
    }
    
    init() {
        print("뷰모델 초기화")
    }
    
}
