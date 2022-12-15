struct DogImage: Decodable {
    let fileSizeBytes: Int?
    let url: String?
}

struct FoxImage: Decodable {
    let image: String
}
