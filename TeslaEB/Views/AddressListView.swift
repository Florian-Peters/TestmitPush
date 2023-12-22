import SwiftUI

struct AddressListView: View {
    @ObservedObject var viewModel: AddressViewModel
    @State private var isAddAddressViewPresented = false
    @State private var searchTerm = ""

    var filteredAddresses: [Address] {
        if searchTerm.isEmpty {
            return viewModel.addresses
        } else {
            return viewModel.addresses.filter { containsSearchTerm(address: $0, term: searchTerm) }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("Search", text: $searchTerm)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // List of Addresses
                List(filteredAddresses, id: \.addressID) { address in
                    NavigationLink(destination: AddressDetailsView(address: address, viewModel: viewModel)) {
                        AddressRowView(address: address)
                    }
                }
                .padding()

                // Add Address Button
                HStack {
                    Spacer()

                    Button(action: {
                        isAddAddressViewPresented.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .sheet(isPresented: $isAddAddressViewPresented) {
                        AddAddressView(viewModel: viewModel)
                    }
                }
            }
            .navigationBarTitle("Address List")
            .onAppear {
                // Load initial data when the view appears
                viewModel.fetchData()
            }
        }
    }

    func containsSearchTerm(address: Address, term: String) -> Bool {
        let lowercasedTerm = term.lowercased()

        return address.addressID.description.contains(term) ||
               address.searchName.lowercased().contains(lowercasedTerm) ||
               address.street1.lowercased().contains(lowercasedTerm) ||
               address.city.lowercased().contains(lowercasedTerm)
        // ... add more properties as needed
    }
}
