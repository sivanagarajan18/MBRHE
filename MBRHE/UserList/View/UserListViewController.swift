//
//  UserListViewController.swift
//  MBRHE
//
//  Created by VC on 03/02/24.
//

import UIKit
import Combine

class UserListViewController: UIViewController {
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var userlistTable: UITableView!
    var vm: UserListViewModel!
    var bindings = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loader.isHidden = false
        vm = UserListViewModel()
        vm.bindDetail.receive(on: RunLoop.main).sink { err in
            self.loader.isHidden = true
            if err == nil {
                self.userlistTable.reloadData()
            } else {
                self.displayError(message: err!)
            }
        }.store(in: &bindings)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loader.isHidden = false
        vm.getUserList()
    }
    
    @IBAction func refresh(_ sender: UIButton) {
        self.loader.isHidden = false
        vm.getUserList()
    }
    
    
    func displayError(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.details?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UserListTableViewCell", for: indexPath) as! UserListTableViewCell
        cell.update(vm.details?[indexPath.row])
        return cell
    }
}
