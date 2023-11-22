//
//  AddressListView.swift
//  testmit login
//
//  Created by Florian Peters on 22.11.23.
//

import SwiftUI

struct AddressListView: View {
    @ObservedObject var viewModel: AddressViewModel

    var body: some View {
        VStack {
            List(viewModel.addresses, id: \.addressID) { address in
                NavigationLink(destination: AddressDetailsView(address: address)) {
                    AddressRowView(address: address)
                }
            }
            .padding()

            Button("Fetch Data") {
                viewModel.fetchData()
            }
            .padding()
        }
        .navigationBarTitle("Address List")
    }
}



