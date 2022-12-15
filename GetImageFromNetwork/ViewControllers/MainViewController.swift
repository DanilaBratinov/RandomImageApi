import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", image: nil, target: nil, action: nil)
    }
    
    var animalType = ""

    @IBAction func imageButtons(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            animalType = "dog"
        case 1:
            animalType = "fox"
        default:
            break
        }
        
        performSegue(withIdentifier: "next", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let imageVC = segue.destination as? ImageViewController else { return }
        imageVC.animalType = animalType
    }
}

