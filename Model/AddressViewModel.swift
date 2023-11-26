import Foundation

class AddressViewModel: ObservableObject {
    @Published var addresses: [Address] = []

    func fetchData() {
        guard let url = URL(string: "http://192.168.178.55:3000/address") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode([Address].self, from: data)
                    DispatchQueue.main.async {
                        self.addresses = decodedData
                        // Save data to UserDefaults
                        self.saveDataToUserDefaults()
                    }
                } catch let error {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }

    private func saveDataToUserDefaults() {
        if let encodedData = try? JSONEncoder().encode(addresses) {
            UserDefaults.standard.set(encodedData, forKey: "addresses")
        }
    }

    func loadDataFromUserDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: "addresses"),
           let decodedData = try? JSONDecoder().decode([Address].self, from: savedData) {
            self.addresses = decodedData
        }
    }

    func addAddress(searchName: String, street1: String, city: String ) {
        guard let url = URL(string: "http://192.168.178.55:3000/address") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let newAddress = Address(addressID: 0, searchName: searchName, street1: street1, city: city)

        do {
            let requestData = try JSONEncoder().encode(newAddress)
            request.httpBody = requestData
        } catch {
            print("Error encoding new address: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error adding address: \(error)")
            } else {
                self.fetchData()
            }
        }.resume()
    }

    func deleteAddress(addressID: Int) {
        guard let url = URL(string: "http://192.168.178.55:3000/address/\(addressID)") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error deleting address: \(error)")
            } else {
                self.fetchData()
            }
        }.resume()
    }
}
