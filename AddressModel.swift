//
//  AddressModel.swift
//  testmit login
//
//  Created by Florian Peters on 22.11.23.
//

import Foundation

struct Address: Codable, Equatable {
    let addressID: Int
    let searchName: String
    let street1: String
    let city : String

    private enum CodingKeys: String, CodingKey {
        case addressID = "AddressID"
        case searchName = "SearchName"
        case street1 = "Street1"
        case city = "City"
    }
}

