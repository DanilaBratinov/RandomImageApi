import Foundation
import Alamofire

enum Link: String {
    case dogURL = "https://dog.ceo/api/breeds/image/random"
    case foxURL = "https://randomfox.ca/floof/"
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}

    func fetchImages(from url: String, completion: @escaping(Result<Data, AFError>) -> Void) {
        AF.request(url)
            .validate()
            .responseData { dataResponse in
                switch dataResponse.result {
                case .success(let imageData):
                    completion(.success(imageData))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
