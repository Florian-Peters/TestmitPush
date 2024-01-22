// AddressDetailsView.swift

import SwiftUI

struct AddressDetailsView: View {
    var address: Address
    @ObservedObject var viewModel: AddressViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var showingDeleteAlert = false
    @State private var updatedAddressName: String
    @State private var updatedAddressStreet: String
    @State private var updatedCity: String

    init(address: Address, viewModel: AddressViewModel) {
        self.address = address
        self.viewModel = viewModel
        self._updatedAddressName = State(initialValue: address.searchName ?? "")
        self._updatedAddressStreet = State(initialValue: address.street1 ?? "")
        self._updatedCity = State(initialValue: address.city ?? "")
    }

    var body: some View {
        List {
            Section(header: Text("Address ID: \(address.addressID)")) {
                ForEach([
                    ("Search Name", $updatedAddressName),
                    ("Street1", $updatedAddressStreet),
                    ("City", $updatedCity)
                ], id: \.0) { field, binding in
                    HStack {
                        Text("\(field):")
                            .frame(width: 100, alignment: .leading)
                        TextField(field, text: binding)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
            }

            Section {
                Button("Update Address") {
                    updateAddress()
                }

                Button("Delete Address") {
                    showingDeleteAlert.toggle()
                }
                .foregroundColor(.red)
                .alert(isPresented: $showingDeleteAlert) {
                    Alert(
                        title: Text("Delete Address"),
                        message: Text("Are you sure you want to delete this address?"),
                        primaryButton: .destructive(Text("Delete")) {
                            deleteAddress()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
        }
        .navigationBarTitle("Address Details")
        .padding()
    }

    func updateAddress() {
        let updatedName = updatedAddressName.isEmpty ? address.searchName ?? "" : updatedAddressName
        let updatedStreet = updatedAddressStreet.isEmpty ? address.street1 ?? "" : updatedAddressStreet
        let updatedCity = updatedCity.isEmpty ? address.city ?? "" : updatedCity

        guard let url = URL(string: "http://192.168.178.58/jtheseus/service?token=6F67F25F-4794-4B3D-A2DC-B2C392C2B1B2&addressid=\(address.addressID)&searchname=\(updatedName)") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                if let resultString = String(data: data, encoding: .utf8) {
                    print("Result: \(resultString)")

                    DispatchQueue.main.async {
                        viewModel.updateAddress(searchName: updatedName, street1: updatedStreet, city: updatedCity)
                    }
                } else {
                    print("Unable to convert data to string")
                }
            }
        }.resume()
    }

    func deleteAddress() {
        guard let url = URL(string: "http://192.168.178.58/jtheseus/service?token=9BF6C326-E34C-40F0-ACF7-77F331D8D76E&addressid=\(address.addressID)")  else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                if let resultString = String(data: data, encoding: .utf8) {
                    print("Result: \(resultString)")

                    DispatchQueue.main.async {
                        viewModel.deleteAddress(addressID: address.addressID)
                        presentationMode.wrappedValue.dismiss()
                    }
                } else {
                    print("Unable to convert data to string")
                }
            }
        }.resume()
    }
}
