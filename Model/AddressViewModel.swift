import Foundation

class AddressViewModel: ObservableObject {
    @Published var addresses: [Address] = []

    func fetchData() {
        guard let url = URL(string: "http://192.168.178.58/jtheseus/service?token=token") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Fehler beim Abrufen der Daten: \(error?.localizedDescription ?? "Unbekannter Fehler")")
                return
            }

            do {
                let decodedData = try JSONDecoder().decode([Address].self, from: data)
                DispatchQueue.main.async {
                    self.addresses = decodedData
                    self.saveDataToUserDefaults() // Save to UserDefaults
                }
            } catch {
                print("Fehler beim Decodieren der Daten: \(error.localizedDescription)")
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

    func addAddress(searchName: String, street1: String, city: String) {
        // Hier können Sie je nach Bedarf die Implementierung für das Hinzufügen von Adressen ergänzen.
        // Beispiel: Implementierung einer POST-Anfrage an die API, um eine Adresse hinzuzufügen.
    }

    func deleteAddress(addressID: Int) {
        // Hier können Sie je nach Bedarf die Implementierung für das Löschen von Adressen ergänzen.
        // Beispiel: Implementierung einer DELETE-Anfrage an die API, um eine Adresse zu löschen.
    }
}
