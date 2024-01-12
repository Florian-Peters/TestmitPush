import SwiftUI

struct AddressDetailsView: View {
    var address: Address
    @State private var showingDeleteAlert = false

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

            Button(action: {
                showingDeleteAlert = true
            }) {
                Image(systemName: "trash")
                    .resizable()
                    .frame(width: 35, height: 35)
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
        .navigationBarTitle("Address Details")
        .padding()
    }
}
