//
//  AddressModel.swift
//  testmit login
//
//  Created by Florian Peters on 22.11.23.
//

import Foundation

struct Address: Codable {
    let addressID: Int
    let searchName: String
    let Street1: String

    private enum CodingKeys: String, CodingKey {
        case addressID = "AddressID"
        case searchName = "SearchName"
        case Street1 = "Street1"
    }
}
