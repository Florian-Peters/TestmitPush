import SwiftUI

struct AddressDetailsView: View {
    var address: Address
    @State private var showingDeleteAlert = false
    @State private var isEditViewPresented = false

    // Inject AddressViewModel to access deleteAddress method
    @ObservedObject var viewModel: AddressViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Group {
                Text("Address ID: \(address.addressID)")
                Text("Search Name: \(address.searchName ?? "")")
                Text("Street1: \(address.street1 ?? "")")
            }
            .padding()

            Spacer()

            HStack {
                Button(action: {
                    isEditViewPresented.toggle()
                }) {
                    Image(systemName: "pencil")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.blue)
                }
                .padding()

                Button(action: {
                    showingDeleteAlert.toggle()
                }) {
                    Image(systemName: "trash")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.red)
                }
                .alert(isPresented: $showingDeleteAlert) {
                    Alert(
                        title: Text("Delete Address"),
                        message: Text("Are you sure you want to delete this address?"),
                        primaryButton: .destructive(Text("Delete")) {
                            // Perform deletion action
                            viewModel.deleteAddress(addressID: address.addressID)
                            // Dismiss the current view (go back to AddressListView)
                            presentationMode.wrappedValue.dismiss()
                        },
                        secondaryButton: .cancel()
                    )
                }
                .padding()
            }
        }
        .navigationBarTitle("Address Details")
        .padding()
        .sheet(isPresented: $isEditViewPresented) {
            UpdateAddressView(address: address, viewModel: viewModel)
        }
    }
}
