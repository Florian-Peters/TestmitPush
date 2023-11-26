//
//  AddressRowView.swift
//  testmit login
//
//  Created by Florian Peters on 22.11.23.
//

import SwiftUI

struct AddressRowView: View {
    var address: Address

    var body: some View {
        VStack(alignment: .leading) {
            Text("Address ID: \(address.addressID)")
            Text("Search Name: \(address.searchName)")
            Text("Street1: \(address.street1)")
        }
    }
}
