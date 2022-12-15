import UIKit

class ImageViewController: UIViewController {
    
    var animalType = ""
    
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

extension ImageViewController {
    private func changeAnimalType() {
        switch animalType {
        case "dog":
            fetchDogImage()
        case "fox":
            fetchFoxImage()
        default:
            fetchDogImage()
            print("Error")
        }
    }
    
    private func fetchDogImage() {
        NetworkManager.shared.fetch(DogImage.self, from: Link.dogURL.rawValue) { [weak self] result in
            switch result {
            case .success(let data):
                
                print("Image: \(data.url ?? "nil"), size: \(data.fileSizeBytes ?? 0) bytes")
                if data.url?.last == "g" || data.url?.last == "G" {
                    self?.setImage(with: data.url ?? "")
                } else {
                    self?.fetchDogImage()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchFoxImage() {
        NetworkManager.shared.fetch(FoxImage.self, from: Link.foxURL.rawValue) { [weak self] result in
            switch result {
            case .success(let data):
                print("Image: \(data.image)")
                self?.setImage(with: data.image)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setImage(with url: String) {
        NetworkManager.shared.fetchImage(from: url) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.imageView.image = UIImage(data: imageData)
                self?.activityIndicator.stopAnimating()
            case .failure(let error):
                print(error)
            }
        }
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
