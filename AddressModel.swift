//
//  AddressModel.swift
//  testmit login
//
//  Created by Florian Peters on 22.11.23.
//

import Foundation

struct Address: Codable, Identifiable {
    let addressID: Int
    let searchName: String
    let street1: String
    let city: String
    
    var id: Int { addressID } // Add this computed property to conform to Identifiable


    private enum CodingKeys: String, CodingKey {
        case addressID = "addressid"
        case searchName = "anzeigename"
        case street1 = "strasse"
        case city = "ort"
    }
}
