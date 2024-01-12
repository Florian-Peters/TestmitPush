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
        // Hier können Sie je nach Bedarf die Implementierung für das Hinzufügen von Adressen ergänzen.
        // Beispiel: Implementierung einer POST-Anfrage an die API, um eine Adresse hinzuzufügen.
    }

    func deleteAddress(addressID: Int) {
        // Hier können Sie je nach Bedarf die Implementierung für das Löschen von Adressen ergänzen.
        // Beispiel: Implementierung einer DELETE-Anfrage an die API, um eine Adresse zu löschen.
    }
}
