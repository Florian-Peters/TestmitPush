import SwiftUI

struct AddAddressView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AddressViewModel
    @State private var newAddressName = ""
    @State private var newAddressStreet = ""
    @State private var newCity = "" // Corrected variable name

    var body: some View {
        VStack {
            TextField("SearchName", text: $newAddressName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Street", text: $newAddressStreet)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("City", text: $newCity) // Added city text field
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Add Address") {
                addAddress()
            }
            .padding()
        }
        .padding()
        .navigationBarTitle("Add Address")
    }

    func addAddress() {
        guard let url = URL(string: "http://192.168.178.58/jtheseus/service?token=14623655-7E8C-43C3-8D99-BA637C2BBF2D&searchname=\(newAddressName)&housenumber=\(newAddressStreet)&street1=Muster&zip1=41068&city=\(newCity)") else {
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
                        viewModel.addAddress(searchName: newAddressName, street1: newAddressStreet, city: newCity)
                        // Dismiss the current view (AddAddressView)
                        presentationMode.wrappedValue.dismiss()
                    }
                } else {
                    print("Unable to convert data to string")
                }
            }
        }.resume()
    }
}
