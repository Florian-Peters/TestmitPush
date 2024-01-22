import Foundation



class AddressViewModel: ObservableObject {
    @Published var addresses: [Address] = []

    func fetchData() {
        guard let url = URL(string: "http://192.168.178.58/jtheseus/service?token=12FBA45F-06E9-4EBD-B306-3BCEA2D5F85E") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error retrieving data:", error?.localizedDescription ?? "Unknown error")
                return
            }

            do {
                let decodedData = try JSONDecoder().decode([Address].self, from: data)
                DispatchQueue.main.async {
                    self.addresses = decodedData
                    self.saveDataToUserDefaults()
                }
            } catch {
                print("Error decoding data:", error.localizedDescription)
            }
        }.resume()
    }

    func saveDataToUserDefaults() {
        do {
            let encodedData = try JSONEncoder().encode(addresses)
            UserDefaults.standard.set(encodedData, forKey: "addresses")
        } catch {
            print("Error encoding data:", error.localizedDescription)
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
                print("Error decoding data from UserDefaults:", error.localizedDescription)
            }
        } else {
            print("No data found in UserDefaults.")
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
                        self.fetchData()
                    }
                } else {
                    print("Unable to convert data to string")
                }
            }
        }.resume()
    }

    func updateAddress(searchName: String, street1: String, city: String) {
        guard let url = URL(string: "http://192.168.178.58/jtheseus/service?token=yourToken&addressid=yourAddressID&searchname=\(searchName)&housenumber=\(street1)&street1=Muster&zip1=41068&city=\(city)") else {
            print("Invalid URL for updating address")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                print("Update Result: \(String(data: data, encoding: .utf8) ?? "")")

                DispatchQueue.main.async {
                    self.fetchData()
                }
            }
        }.resume()
    }

    func deleteAddress(addressID: Int) {
        if let index = addresses.firstIndex(where: { $0.addressID == addressID }) {
            addresses.remove(at: index)
            saveDataToUserDefaults()
        }
    }
}
