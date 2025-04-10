//
//  MarkerInfo.swift
//  ZesulE
//
//  Created by 시모니 on 4/7/25.
//

import Foundation
import NMapsMap

struct MarkerInfo: Identifiable {
    let id = UUID()
    let lat: Double
    let lng: Double
    let detlCn: String
    let mgcNm: String
    let sboxNum: String
}

struct MarkerItem {
    let marker: NMFMarker
    let info: MarkerInfo
}
