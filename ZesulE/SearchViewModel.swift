//
//  SearchViewModel.swift
//  ZesulE
//
//  Created by 시모니 on 12/31/23.
//

import Foundation
import Firebase
import FirebaseDatabaseInternal

class SearchViewModel {
    
    let db = Database.database().reference()
    var userSearch: String = ""
    var dataArray: [String] = []
    
    func fetchData(searchtext: String) {
        db.child("DATA").observeSingleEvent(of: .value) { [self] (snapshot) in
            guard let data = snapshot.value as? [[String: Any]] else {
                print("Failed to fetch data from Firebase")
                return
            }
            // 검색어를 소문자로 변환하여 대소문자 구분 없이 검색할 수 있도록 함
            let searchText = searchtext
            dataArray = []
            
            for item in data {
                if let detlCn = item["detl_cn"] as? String {
                    // detlCn 문자열에 검색어가 포함되어 있는지 확인
                    if detlCn.contains(searchText) {
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
