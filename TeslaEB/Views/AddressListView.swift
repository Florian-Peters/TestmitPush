import SwiftUI

struct AddressListView: View {
    @ObservedObject var viewModel: AddressViewModel
    @State private var isAddAddressViewPresented = false
    @State private var searchTerm = ""

    var body: some View {
        NavigationView {
            ZStack {  // Use ZStack to layer views
                // Background
                Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)  // Light gray background

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

                    // Add Address Button
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
                .navigationBarTitle("Address List", displayMode: .inline)
                .onAppear {
                    viewModel.fetchData()
                }
            }
        }
    }

    var filteredAddresses: [Address] {
        if searchTerm.isEmpty {
            return viewModel.addresses
        } else {
            return viewModel.addresses.filter { containsSearchTerm(address: $0, term: searchTerm) }
        }
    }

    func containsSearchTerm(address: Address, term: String) -> Bool {
        let lowercasedTerm = term.lowercased()
        return address.addressID.description.contains(term) ||
            (address.searchName?.lowercased().contains(lowercasedTerm) ?? false)
    }

    var logoImage: some View {
        Image("TLC-Logo-mit-Text")
            .resizable()
            .scaledToFit()
            .frame(width: 150, height: 150)  // Increase the size of the logo
            .padding()
    }
}

