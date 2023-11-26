//
//  AddAddressView.swift
//  testmit login
//
//  Created by Florian Peters on 26.11.23.
//

import SwiftUI
    

struct AddAddressView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AddressViewModel
    @State private var newAddressName = ""
    @State private var newAddressStreet = ""
    @State private var newcity = ""
    

    var body: some View {
        VStack {
            TextField("SearchName", text: $newAddressName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Street", text: $newAddressStreet)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Add Address") {
                viewModel.addAddress(searchName: newAddressName, street1: newAddressStreet, city: newcity)
                // Dismiss the current view (AddAddressView)
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
        .padding()
        .navigationBarTitle("Add Address")
    }
}
