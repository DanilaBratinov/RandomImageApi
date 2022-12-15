import Foundation

enum Link: String {
    case dogURL = "https://random.dog/woof.json"
    case foxURL = "https://randomfox.ca/floof/"
}

enum NetworkError: Error {
case invalidURL
case noData
case decodingError
}

class NetworkManager {
    static let shared = NetworkManager()
    
    func fetch<T: Decodable>(_ type: T.Type, from url: String, completion: @escaping(Result <T, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else {
                completion(.failure(.noData))
                return
            }
            do {
                let type = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(type))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func fetchImage(from url: String?, completion: @escaping (Result <Data, NetworkError>) -> Void) {
        guard let url = URL(string: url ?? "") else {
            completion(.failure(.invalidURL))
            return
        }
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.noData))
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
    
    private init() {}
}
