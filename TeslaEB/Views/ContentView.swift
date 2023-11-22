import SwiftUI
import WebKit


struct ContentView: View {
    @StateObject var viewModel = AddressViewModel()

    var body: some View {
        NavigationView {
            VStack {
                // WebView
                WebView(request: URLRequest(url: URL(string: "http://192.168.178.58/jtheseus/servlet/jtheseus.server.JTheseusServlet?User=")!))

                // Address List
                NavigationLink(destination: AddressListView(viewModel: viewModel)) {
                    Text("Show Address List")
                        .padding()
                }
            }
            .onAppear {
                // Beim Erscheinen der ContentView die Daten aus UserDefaults laden
                viewModel.loadDataFromUserDefaults()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
