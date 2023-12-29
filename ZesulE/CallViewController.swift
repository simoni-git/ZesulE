//
//  CallViewController.swift
//  ZesulE
//
//  Created by 시모니 on 12/29/23.
//

import UIKit

class CallViewController: UIViewController {
    
    var vm: CallViewModel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm = CallViewModel()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

extension CallViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.mgcNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CallCell") as? CallCell else {
            return UITableViewCell()
        }
        let nameData = vm.mgcNames[indexPath.row]
        let numberData = vm.mgcNums[indexPath.row]
        
        cell.mgcNM.text = nameData
        cell.mgcNumber.text = numberData
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension CallViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}


