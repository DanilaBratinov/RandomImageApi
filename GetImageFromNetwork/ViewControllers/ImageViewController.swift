import UIKit
import Alamofire

class ImageViewController: UIViewController {
    
    var animalType: AnimalType!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        changeAnimalType()
        imageView.startAnimating()
    }
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        imageView.image = nil
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        changeAnimalType()
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        guard let image = imageView.image else { return }
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        showAlert()
    }
}

//MARK: - FetchImages

extension ImageViewController {
    private func fetchImages(from url: String) {
        NetworkManager.shared.fetchImages(from: url) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.imageView.image = UIImage(data: imageData)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchDogImages() {
        AF.request(Link.dogURL.rawValue)
            .responseJSON { [weak self] dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    guard let imageData = value as? [String: Any] else { return }
                    let image = DogImage(imageData: imageData)
                    self?.fetchImages(from: image.message)
                    self?.activityIndicator.stopAnimating()
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    private func fetchFoxImages() {
        AF.request(Link.foxURL.rawValue)
            .responseJSON { [weak self] dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    guard let imageData = value as? [String: Any] else { return }
                    let image = FoxImage.init(imageData: imageData)
                    self?.fetchImages(from: image.image)
                    self?.activityIndicator.stopAnimating()
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    private func changeAnimalType() {
        animalType == .dog ? fetchDogImages() : fetchFoxImages()
    }
}

extension ImageViewController {
    private func showAlert() {
        let alert = UIAlertController(title: "Успешно", message: "Изображение добавлено в фотоальбом", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}

