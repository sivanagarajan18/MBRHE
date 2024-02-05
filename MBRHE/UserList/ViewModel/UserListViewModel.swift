//
//  UserListViewModel.swift
//  MBRHE
//
//  Created by VC on 03/02/24.
//

import Foundation
import Combine

class UserListViewModel: NSObject {
    var details: [Users]? {
        didSet {
            bindDetail.send(nil)
        }
    }
    
    var bindDetail = PassthroughSubject<String?, Never>()
    override init() {
        super.init()
        getUserList()
    }
    
    func getUserList() {
        APIService.request(endpoints: .Users, method: .get) { [weak self] (result: Result<[Users], Error>, dataSet) in
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
