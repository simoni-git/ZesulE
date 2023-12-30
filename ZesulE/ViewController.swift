//
//  ViewController.swift
//  ZesulE
//
//  Created by 시모니 on 12/28/23.
//

// 이미지 만들어서 넣어야할곳 1.앱아이콘 2.infoView이미지 3.탭바컨트롤러이미지 4.런치스크린이미지(런치시간3초정도 갖을것)


import UIKit
import Firebase
import NMapsMap
import CoreLocation
import FirebaseDatabaseInternal

class ViewController: UIViewController , DelegateProtocol {
    
    @IBOutlet weak var mapView: NMFMapView!
    @IBOutlet weak var imfoView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var myLocationBtn: UIButton!
    
    @IBOutlet weak var boxLocationInfoLabel: UILabel!
    @IBOutlet weak var boxNumberLabel: UILabel!
    @IBOutlet weak var boxObseveName: UILabel!
    
    let db = Database.database().reference()
    var locationManager: CLLocationManager!
    var currentCircle: NMFCircleOverlay?
    var selectedMarker: NMFMarker?
    var markers: [NMFMarker] = []  // 마커를 저장할 배열
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeMarking()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 정확도증가
        getLocationUsagePermission()
        configureUI()
        startLocationIsUserLocation()
    }
    
   private func makeCircle(lat: Double , lng: Double) {
        if let existingCircle = currentCircle {
            existingCircle.mapView = nil
        }
        
        let circle = NMFCircleOverlay()
        circle.center = NMGLatLng(lat: lat, lng: lng)
        circle.radius = 500
        circle.fillColor = UIColor.clear
        circle.outlineWidth = 5
        circle.outlineColor = UIColor.yellow
        circle.mapView = mapView
        
        currentCircle = circle
    }
    
    @IBAction func tapSearchBtn(_ sender: UIButton) {
        print("까꿍 내가눌렸지!")
        guard let SearchVC = self.storyboard!.instantiateViewController(identifier: "SearchViewController") as? SearchViewController else {return}
        self.navigationController?.pushViewController(SearchVC, animated: true)
        SearchVC.delegate = self
    }
    
   private func configureUI() {
        self.imfoView.layer.cornerRadius = 10
        self.myLocationBtn.layer.cornerRadius = 10
        self.searchBar.layer.cornerRadius = 10
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //⬇️내 현위치로 이동
    @IBAction func tapMyLocationBtn(_ sender: UIButton) {
        print("tapMyLocationBtn 눌렸다! 내위치 ㅇㄷ??")
        if let currentLocation = locationManager.location?.coordinate {
            print("현재 위치: \(currentLocation.latitude), \(currentLocation.longitude)")
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: currentLocation.latitude, lng: currentLocation.longitude))
            mapView.moveCamera(cameraUpdate)
            mapView.positionMode = .direction
            makeCircle(lat: currentLocation.latitude, lng: currentLocation.longitude)
            
            self.boxLocationInfoLabel.text = "마커를 누르면 정보가 보여집니다."
            self.boxNumberLabel.text = "나침판 버튼을 누르면 현재 위치로 이동 합니다."
            self.boxObseveName.text = "노란색 동그라미는 반경 500m 입니다."
            
        } else {
            print("현재 위치를 가져올 수 없음")
        }
    }
    
    private func startLocationIsUserLocation() {
        print("우선 시작지점은 사용자의 위치권한이 허용됬으니 사용자위치로 바로이동")
        if let currentLocation = locationManager.location?.coordinate {
            print("현재 위치: \(currentLocation.latitude), \(currentLocation.longitude)")
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: currentLocation.latitude, lng: currentLocation.longitude))
            mapView.moveCamera(cameraUpdate)
            mapView.positionMode = .direction
            makeCircle(lat: currentLocation.latitude, lng: currentLocation.longitude)
            
            self.boxLocationInfoLabel.text = "마커를 누르면 정보가 보여집니다."
            self.boxNumberLabel.text = "나침판 버튼을 누르면 현재 위치로 이동 합니다."
            self.boxObseveName.text = "노란색 동그라미는 반경 500m 입니다."
            
        } else {
            print("현재 위치를 가져올 수 없음")
        }
    }
    
    private func makeMarking() {
        db.child("DATA").observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard let data = snapshot.value as? [[String: Any]] else {
                print("Failed to fetch data from Firebase")
                return
            }
            for item in data {
            
                if let latitude = item["lat"] as? Double,
                   let longitude = item["lng"] as? Double,
                   let detlCn = item["detl_cn"] as? String,
                   let mgcNm = item["mgc_nm"] as? String,
                   let sboxNum = item["sbox_num"] as? String {

                    let marker = NMFMarker()
                    marker.position = NMGLatLng(lat: latitude, lng: longitude)
                    self?.markers.append(marker)
                    print("마커갯수는 --> \(self!.markers.count)")
                    DispatchQueue.main.async {
                        marker.mapView = self!.mapView
                    }
                    //마커를 눌렀을때 호출될 핸들러(마커누르면 해당데이터 뷰라벨에 표시)
                    marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                        print("마커가 눌렸다!! 마커위치 --> \(marker.position)")
                        
                        if let prevSelectedMarker = self?.selectedMarker {
                            prevSelectedMarker.iconImage = NMF_MARKER_IMAGE_GREEN
                        }
                        // 선택된 마커의 이미지를 빨간색으로 변경
                        marker.iconImage = NMF_MARKER_IMAGE_RED
                        
                        // 선택된 마커를 변수에 저장
                        self?.selectedMarker = marker
                        
                        self?.boxLocationInfoLabel.text = "위치상세주소: \(detlCn)"
                        self?.boxNumberLabel.text = "제설함 고유번호: \(sboxNum)"
                        self?.boxObseveName.text = "관리구: \(mgcNm)청"
                        
                        return true
                    }
                    
                } else {
                    print("Invalid or missing latitude/longitude data in item: \(item)")
                }
            }
        }
    }
    
}

extension ViewController: NMFMapViewCameraDelegate {
    //⬇️ SearchVC 에서 넘어온 정보를 토대로 좌표로 이동.
    func didSelectItem(_ item: String) {
        print("이거 실행은된다?")
        db.child("DATA").observeSingleEvent(of: .value) {[weak self] (snapshot) in
            guard let data = snapshot.value as? [[String: Any]] else {
                print("Failed to fetch data from Firebase")
                return
            }
            
            if let matchingItem = data.first(where: { $0["detl_cn"] as? String == item }),
               let latitude = matchingItem["lat"] as? Double,
               let longitude = matchingItem["lng"] as? Double,
               let detlCn = matchingItem["detl_cn"] as? String,
               let mgcNm = matchingItem["mgc_nm"] as? String,
               let sboxNum = matchingItem["sbox_num"] as? String {
                
                self?.selectedMarker?.iconImage = NMF_MARKER_IMAGE_GREEN
                
                let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude))
                DispatchQueue.main.async {
                    self?.mapView.moveCamera(cameraUpdate)
                    self?.boxLocationInfoLabel.text = "위치상세주소: \(detlCn)"
                    self?.boxNumberLabel.text = "제설함 고유번호: \(sboxNum)"
                    self?.boxObseveName.text = "관리구: \(mgcNm)청"
                }
                if let marker = self?.markers.first(where: { $0.position.lat == latitude && $0.position.lng == longitude }) {
                    marker.iconImage = NMF_MARKER_IMAGE_RED
                    self?.selectedMarker = marker
                }
                
                print("여기까지 넘어오긴하나??")
                
            }
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



