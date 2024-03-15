# ❄️ZesulE - 제설이 , 서울시 제설함 위치 앱

## 🔨사용기술
- Swift
- Storyboard
- MVC
- Firebase
- SPM
- NMaps

## 🔨사용기술 예시코드
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
⬆️ Firebase 에 저장된 데이터를 기반으로 제설함 위치에 마커 생성  

    extension SearchViewController: UISearchBarDelegate {

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
        // ⬇️ 서치바에 값이 바뀔 때마다 호출됨.
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            guard !searchText.isEmpty else {
                dataArray.removeAll()
                tableView.reloadData()
                return
            }
    
            db.child("DATA").observeSingleEvent(of: .value) { [self] (snapshot) in
                guard let data = snapshot.value as? [[String: Any]] else {
                    print("Failed to fetch data from Firebase")
                    return
                }
       
                let userSearchText = searchText
                dataArray = []
        
                for item in data {
                    if let detlCn = item["detl_cn"] as? String {
                        // detlCn 문자열에 검색어가 포함되어 있는지 확인
                        if detlCn.contains(userSearchText) {
                            // 검색어가 포함된 데이터에 대한 처리
                            // 예: 해당 데이터를 화면에 표시하거나 다른 작업을 수행
                            dataArray.append(detlCn)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }

    }
⬆️ Firebase 에 있는 데이터를 기반으로 SearchBar 에 검색  

## 🔍앱의 주요기능
- 사용자의 현재 위치정보를 토대로 주변 제설함 위치 제공
- 도로명 및 주소 검색을 통한 제설함 위치 제공
- 제설함 관리정보 및 관리기관번호 제공



## 👨‍💻프로젝트를 계획한 이유
- 외부 SDK와 공공데이터를 토대로 앱을 만들어 보려고 하였습니다.    
- 공공데이터를 확인해 보니 제설함 위치가 좌료로만 되어있어 한눈에 알아보기 힘든점이 있어서  
보기쉽게 구현하게 되었습니다.


## 🤓배포과정에서 느낀점
- 사용하고자 하는 좌표와 공공데이터의 좌표의 종류가 달라 엑셀을 통해 변환하게 되었고  
그것을 다시 JSON 으로 파싱하면서 데이터를 변환하는 과정을 경험하였습니다.
- 위 과정을 통해 네트워킹방법 보다는 데이터파일을 저장할 곳이 필요했고  
  데이터저장 방법을 Firebase 를 선택하면서 Firebase 를 경험하였습니다.

