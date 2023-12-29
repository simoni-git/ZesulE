//
//  SearchViewController.swift
//  ZesulE
//
//  Created by 시모니 on 12/29/23.
//

import UIKit
import Firebase
import FirebaseDatabaseInternal

protocol DelegateProtocol {
    func didSelectItem(_ item: String)
}

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Database.database().reference()
    var delegate: DelegateProtocol?
    
    var userSearch: String = ""
    var dataArray: [String] = []
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
   
}

extension SearchViewController: UISearchBarDelegate {
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

               // 검색어를 소문자로 변환하여 대소문자 구분 없이 검색할 수 있도록 함
               let lowercaseSearchText = searchText.lowercased()
               dataArray = []

               for item in data {
                   if let detlCn = item["detl_cn"] as? String {
                       // detlCn 문자열에 검색어가 포함되어 있는지 확인
                       if detlCn.lowercased().contains(lowercaseSearchText) {
                           // 검색어가 포함된 데이터에 대한 처리
                           // 예: 해당 데이터를 화면에 표시하거나 다른 작업을 수행
                           dataArray.append(detlCn)
                       }
                   }
               }
               self.tableView.reloadData()
           }
       }
    
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as? SearchCell else {
            return UITableViewCell()
        }
        let data = dataArray[indexPath.row]
        cell.detlNM.text = "상세주소: \(data)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = dataArray[indexPath.row]
        delegate?.didSelectItem(selectedItem)
        navigationController?.popViewController(animated: true)
    }
    
    
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

