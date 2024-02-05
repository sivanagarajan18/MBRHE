//
//  UsersList.swift
//  MBRHE
//
//  Created by VC on 03/02/24.
//

import Foundation

struct Users:
    Codable {
    let id: Int?
    let name, email: String?
    let gender: String?
    let status: String?
}

