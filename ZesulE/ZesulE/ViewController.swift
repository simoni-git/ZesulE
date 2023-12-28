//
//  ViewController.swift
//  ZesulE
//
//  Created by 시모니 on 12/28/23.
//

import UIKit
import Firebase
import NMapsMap
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: NMFMapView!
    @IBOutlet weak var imfoView: UIView!
    @IBOutlet weak var myLocationBtn: UIButton!
    
    
    @IBOutlet weak var boxLocationInfoLabel: UILabel!
    @IBOutlet weak var boxNumberLabel: UILabel!
    @IBOutlet weak var boxObseveName: UILabel!
    
    
    
    var locationManager: CLLocationManager!
    var currentCircle: NMFCircleOverlay?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 정확도증가
        getLocationUsagePermission()
        configureUI()
        mapView.touchDelegate = self
        
    }
    
    func configureUI() {
        self.imfoView.layer.cornerRadius = 10
        self.myLocationBtn.layer.cornerRadius = 10
    }
    
    @IBAction func tapMyLocationBtn(_ sender: UIButton) {
        print("tapMyLocationBtn 눌렸다! 내위치 ㅇㄷ??")
        if let currentLocation = locationManager.location?.coordinate {
            print("현재 위치: \(currentLocation.latitude), \(currentLocation.longitude)")
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: currentLocation.latitude, lng: currentLocation.longitude))
            mapView.moveCamera(cameraUpdate)
        mapView.positionMode = .direction
        } else {
            print("현재 위치를 가져올 수 없음")
        }
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func getLocationUsagePermission() {
           self.locationManager.requestWhenInUseAuthorization()
        print("권한 물어보자")
       }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                print("GPS 권한 설정됨")
                self.locationManager.startUpdatingLocation()
            case .restricted, .notDetermined:
                print("GPS 권한 설정되지 않음")
                getLocationUsagePermission()
            case .denied:
                print("GPS 권한 요청 거부됨")
                getLocationUsagePermission()
            default:
                print("GPS: Default")
            }
        }
}

extension ViewController: NMFMapViewTouchDelegate {
    //⬇️ 지도를 터치했을때 터치한곳의 위도 경도를 가져와서 그것을 토대로 반경500미터인 원을 만듬
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
           print("터치 위치 - 위도: \(latlng.lat), 경도: \(latlng.lng)")
           //⬇️ 만약 이미 원하나 있다면 없앨꺼임.
        if let existingCircle = currentCircle {
                   existingCircle.mapView = nil
               }
        
        let circle = NMFCircleOverlay()
        circle.center = NMGLatLng(lat: latlng.lat, lng: latlng.lng)
        circle.radius = 500
        circle.fillColor = UIColor.clear
        circle.outlineWidth = 5
        circle.outlineColor = UIColor.green
        circle.mapView = mapView
        
        currentCircle = circle
       }
    
}
