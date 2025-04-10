//
//  SearchVM.swift
//  ZesulE
//
//  Created by 시모니 on 4/7/25.
//

import Foundation
import Alamofire

class SearchVM: ObservableObject {
    
    @Published var suggestions: [SearchResult] = []
    let naverAPI_clientID = "wz4h8i23k6"
    let naverAPI_clientSecret = "Ajxn9hntnXffNNIlJWbOAgz78b1E6omcl59uElHK"
    let naverDevelopersAPI_clientID = "k7OX1iSLXUBaxM0nSIln"
    let naverDevelopersAPI_clientSecret = "RS5RnvcmzH"
    
    func fetchSearchResults(for query: String) {
        suggestions = []
        fetchAddressResults(for: query)
        fetchPlaceResults(for: query)
    }
    
    // ✅ 주소 검색 API 호출 (도로명, 지번 주소 검색)
    private func fetchAddressResults(for query: String) {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=\(encodedQuery)"
        
        let headers: HTTPHeaders = [
            "X-NCP-APIGW-API-KEY-ID": naverAPI_clientID,
            "X-NCP-APIGW-API-KEY": naverAPI_clientSecret
        ]
        
        AF.request(url, headers: headers)
            .validate()
            .responseDecodable(of: GeocodeResponse.self) { response in
                switch response.result {
                case .success(let result):
                    DispatchQueue.main.async {
                        self.suggestions.append(contentsOf: result.addresses.map { address in
                            SearchResult(title: address.roadAddress ?? "주소 없음", latitude: Double(address.y), longitude: Double(address.x))
                        })
                    }
                case .failure(let error):
                    print("주소 검색 실패: \(error.localizedDescription)")
                }
            }
    }
    
    // ✅ 장소 검색 API 호출 (지하철역, 건물명 검색)
    private func fetchPlaceResults(for query: String) {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = "https://openapi.naver.com/v1/search/local.json?query=\(encodedQuery)&display=5"
        
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": naverDevelopersAPI_clientID,
            "X-Naver-Client-Secret": naverDevelopersAPI_clientSecret
        ]
        
        AF.request(url, headers: headers)
            .validate()
            .responseDecodable(of: PlaceSearchResponse.self) { response in
                switch response.result {
                case .success(let result):
                    DispatchQueue.main.async {
                        self.suggestions.append(contentsOf: result.items.map { place in
                            SearchResult(title: place.title.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: ""), latitude: convertYtoLatitude(y: place.mapy), longitude: convertXtoLongitude(x: place.mapx))
                        })
                    }
                    print("네이버 장소 검색 응답: \(result)")
                case .failure(let error):
                    print("장소 검색 실패: \(error.localizedDescription)")
                }
            }
    }
    
}

// ✅ 주소 검색 API 응답 구조
struct GeocodeResponse: Codable {
    let addresses: [Address]
}

struct Address: Codable {
    let roadAddress: String?
    let x: String  // 경도
    let y: String  // 위도
}

// ✅ 장소 검색 API 응답 구조
struct PlaceSearchResponse: Codable {
    let items: [Place]
}

struct Place: Codable {
    let title: String
    let roadAddress: String?
    let mapx: String // 네이버 X 좌표 (경도 변환 필요)
    let mapy: String // 네이버 Y 좌표 (위도 변환 필요)
}

// ✅ 검색 결과를 담는 공통 구조체
struct SearchResult: Identifiable {
    let id = UUID()
    let title: String
    let latitude: Double?
    let longitude: Double?
}

// ✅ 네이버 X, Y 좌표를 위도/경도로 변환
func convertXtoLongitude(x: String) -> Double? {
    if let xValue = Double(x) {
        return xValue / 10_000_000.0
    }
    return nil
}

func convertYtoLatitude(y: String) -> Double? {
    if let yValue = Double(y) {
        return yValue / 10_000_000.0
    }
    return nil
}
