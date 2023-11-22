//
//  AddressViewModel.swift
//  testmit login
//
//  Created by Florian Peters on 22.11.23.
//

import Foundation

class AddressViewModel: ObservableObject {
    @Published var addresses: [Address] = []

    func fetchData() {
        guard let url = URL(string: "http://0.0.0.0:3000/address") else {
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
}
