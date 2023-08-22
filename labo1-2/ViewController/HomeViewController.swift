import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Autres configurations initiales si nécessaire
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tabBarController = segue.destination as? UITabBarController {
            for childVC in tabBarController.viewControllers ?? [] {
                if let movieVC = childVC as? MovieViewController {
                    movieVC.userName = nameTextField.text
                } else if let wordVC = childVC as? WordViewController {
                    wordVC.userName = nameTextField.text
                }
            }
        }
    }
}


