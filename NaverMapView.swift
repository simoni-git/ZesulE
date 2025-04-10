//
//  NaverMapView.swift
//  ZesulE
//
//  Created by 시모니 on 4/7/25.
//

import SwiftUI
import NMapsMap
import CoreLocation

struct NaverMapView: UIViewRepresentable {
    
    @ObservedObject var viewModel: ContentVM
    @Binding var mapView: NMFMapView
    @Binding var currentCircle: NMFCircleOverlay?
    let locationManager = CLLocationManager()
    
    func makeUIView(context: Context) -> NMFMapView {
        mapView.positionMode = .compass // 현재 위치 트래킹 모드 설정
        locationManager.delegate = context.coordinator
        locationManager.requestWhenInUseAuthorization() // 위치 권한 요청
        locationManager.startUpdatingLocation() // 위치 업데이트 시작
        locationManager.startUpdatingHeading() // 🔥 방향(Heading) 업데이트 시작
        
        return mapView
    }
    
    func updateUIView(_ uiView: NMFMapView, context: Context) {
        for markerItem in viewModel.markers {
            markerItem.marker.mapView = uiView
        }
        
        // 👉 선택된 위치가 있다면 그쪽으로 카메라 이동
        if let lat = viewModel.targetLat, let lng = viewModel.targetLng {
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng))
            cameraUpdate.animation = .easeIn
            DispatchQueue.main.async {
                uiView.moveCamera(cameraUpdate)
                makeCircle(lat: lat, lng: lng) // 원도 같이 이동
            }
            
            DispatchQueue.main.async {
                viewModel.targetLat = nil
                viewModel.targetLng = nil
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, CLLocationManagerDelegate {
        var parent: NaverMapView
        
        init(_ parent: NaverMapView) {
            self.parent = parent
        }
        
        // ✅ 현재 위치 업데이트 시 지도 중심 이동
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            guard parent.viewModel.shouldFollowUser else { return } // ✅ 사용자 위치 추적 꺼졌으면 무시
            
            guard let location = locations.last else { return }
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            print("현재 위치: \(latitude), \(longitude)")
            DispatchQueue.main.async {
                self.parent.makeCircle(lat: latitude, lng: longitude)
            }
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude))
            cameraUpdate.animation = .easeIn
            parent.mapView.moveCamera(cameraUpdate)
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("위치 업데이트 실패: \(error.localizedDescription)")
        }
    }
    
    func makeCircle(lat: Double, lng: Double) {
        DispatchQueue.main.async {
            if let existingCircle = currentCircle {
                existingCircle.mapView = nil
            }
            
            let circle = NMFCircleOverlay()
            circle.center = NMGLatLng(lat: lat, lng: lng)
            circle.radius = 500
            circle.fillColor = UIColor.clear
            circle.outlineWidth = 5
            circle.outlineColor = UIColor.orange
            circle.mapView = mapView
            
            currentCircle = circle
        }
    }
    
}

