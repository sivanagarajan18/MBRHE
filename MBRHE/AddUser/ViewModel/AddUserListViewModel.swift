//
//  UserListViewModel.swift
//  MBRHE
//
//  Created by VC on 03/02/24.
//

import Foundation
import Combine

class AddUserListViewModel: NSObject {
    var details: AddUsers? {
        didSet {
            bindDetail.send(nil)
        }
    }
    var bindDetail = PassthroughSubject<String?, Never>()
    func AddUserList(user: AddUsers) {
        APIService.request(endpoints: .Users, parameters: "{\"name\":\"\(user.name!)\",\"gender\":\"\(user.gender!)\",\"status\":\"\(user.status!)\",\"email\":\"\(user.email!)\"}", method: .post) { [weak self] (result: Result<AddUsers, Error>, dataSet) in
            guard let self else {return}
            switch result {
                case .success(let detail):
                    self.details = detail
                case .failure(let err):
                self.bindDetail.send(err.localizedDescription.errorDescription)
            }
        }
    }
}
