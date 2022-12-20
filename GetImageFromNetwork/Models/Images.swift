struct DogImage: Decodable {
    let message: String
    
    init(imageData: [String: Any]) {
        message = imageData["message"] as? String ?? ""
    }
    
    init(message: String, status: String) {
        self.message = message
    }
    
}

struct FoxImage: Decodable {
    let image: String
    
    init(imageData: [String: Any]) {
        image = imageData["image"] as? String ?? ""
    }
    
    init(image: String) {
        self.image = image
    }
}

enum AnimalType {
    case dog
    case fox
}
