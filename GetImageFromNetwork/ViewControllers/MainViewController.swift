import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", image: nil, target: nil, action: nil)
    }
    
    private var animalType: AnimalType = .dog

    @IBAction func imageButtons(_ sender: UIButton) {
        sender.tag == 0 ? (animalType = .dog) : (animalType = .fox)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let imageVC = segue.destination as? ImageViewController else { return }
        imageVC.animalType = animalType
    }
}

