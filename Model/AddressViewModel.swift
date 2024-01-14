import Foundation

class AddressViewModel: ObservableObject {
    @Published var addresses: [Address] = []

    func fetchData() {
        guard let url = URL(string: "http://192.168.178.58/jtheseus/service?token=12FBA45F-06E9-4EBD-B306-3BCEA2D5F85E") else {
            print("Ungültige URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Fehler beim Abrufen der Daten:", error?.localizedDescription ?? "Unbekannter Fehler")
                return
            }

            do {
                let decodedData = try JSONDecoder().decode([Address].self, from: data)
                DispatchQueue.main.async {
                    self.addresses = decodedData
                    self.saveDataToUserDefaults()
                }
            } catch {
                print("Fehler beim Decodieren der Daten:", error.localizedDescription)
            }
        }.resume()
    }

    private func saveDataToUserDefaults() {
        do {
            let encodedData = try JSONEncoder().encode(addresses)
            UserDefaults.standard.set(encodedData, forKey: "addresses")
        } catch {
            print("Fehler beim Codieren der Daten:", error.localizedDescription)
        }
    }

    func loadDataFromUserDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: "addresses") {
            do {
                let decodedData = try JSONDecoder().decode([Address].self, from: savedData)
                DispatchQueue.main.async {
                    self.addresses = decodedData
                }
            } catch {
                print("Fehler beim Decodieren der Daten aus UserDefaults:", error.localizedDescription)
            }
        } else {
            print("Keine Daten in UserDefaults gefunden.")
        }
    }

    func addAddress(searchName: String, street1: String, city: String) {
        guard let url = URL(string: "http://192.168.178.58/jtheseus/service?token=14623655-7E8C-43C3-8D99-BA637C2BBF2D&searchname=\(searchName)&housenumber=\(street1)&street1=Muster&zip1=41068&city=\(city)") else {
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
                        self.fetchData() // Reload data after adding a new address
                    }
                } else {
                    print("Unable to convert data to string")
                }
            }
        }.resume()
    }

    func deleteAddress(addressID: Int) {
        // Implement the logic to delete an address by making a DELETE request to the API.
        // Update the local addresses array and reload data as needed.
        // Example: send a DELETE request to http://your-api-url/addresses/{addressID}
    }

    func updateAddress(searchName: String, street1: String, city: String) {
        // Implement the logic to update an existing address by making a PUT request to the API.
        // Include the necessary parameters (e.g., searchName, street1, city) in the request.
        // Example: send a PUT request to http://your-api-url/addresses/{addressID}

        // Note: Replace "yourUpdateURL" with the actual URL for updating addresses.
        guard let url = URL(string: "yourUpdateURL") else {
            print("Invalid URL for updating address")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        // Include necessary request parameters for updating an address
        // (e.g., searchName, street1, city).

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                // Handle the response data as needed.
                // You may update the local addresses array or perform other actions.
                print("Update Result: \(String(data: data, encoding: .utf8) ?? "")")

                DispatchQueue.main.async {
                    self.fetchData() // Reload data after updating an address
                }
            }
        }.resume()
    }
}
