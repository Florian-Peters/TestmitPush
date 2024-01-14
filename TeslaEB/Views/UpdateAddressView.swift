import SwiftUI

struct UpdateAddressView: View {
    var address: Address
    @State private var updatedAddressName: String
    @State private var updatedAddressStreet: String
    @State private var updatedCity: String

    @ObservedObject var viewModel: AddressViewModel
    @Environment(\.presentationMode) var presentationMode

    init(address: Address, viewModel: AddressViewModel) {
        self.address = address
        self.viewModel = viewModel
        self._updatedAddressName = State(initialValue: address.searchName ?? "")
        self._updatedAddressStreet = State(initialValue: address.street1 ?? "")
        self._updatedCity = State(initialValue: address.city ?? "")
    }

    var body: some View {
        VStack {
            TextField("Search Name", text: $updatedAddressName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Street", text: $updatedAddressStreet)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("City", text: $updatedCity)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Update Address") {
                updateAddress()
            }
            .padding()
        }
        .padding()
        .navigationBarTitle("Update Address")
    }

    // Inside your UpdateAddressView
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

                    // You can update your view model or handle the result as needed
                    DispatchQueue.main.async {
                        viewModel.updateAddress(searchName: updatedName, street1: updatedStreet, city: updatedCity)
                        // Dismiss the current view (UpdateAddressView)
                        presentationMode.wrappedValue.dismiss()
                    }
                } else {
                    print("Unable to convert data to string")
                }
            }
        }.resume()
    }

}
