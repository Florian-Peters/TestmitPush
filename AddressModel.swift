struct Address: Codable, Identifiable {
    let addressID: Int
    let searchName: String?
    let street1: String?
    let city: String?
    
    var id: Int { addressID }
    
    private enum CodingKeys: String, CodingKey {
        case addressID = "addressid"
        case searchName = "anzeigename"
        case street1 = "strasse"
        case city = "ort"
    }
}
