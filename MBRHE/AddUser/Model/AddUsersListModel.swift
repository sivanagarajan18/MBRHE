//
//  UsersList.swift
//  MBRHE
//
//  Created by VC on 03/02/24.
//

import Foundation

struct AddUsers:
    Codable {
    let id: Int!
    let name, email: String!
    let gender: String!
    let status: String!
}

struct ErrorField: Codable {
    let field, message: String?
}
