import UIKit
import CoreData

class HomeViewController: UIViewController {
    var context: NSManagedObjectContext?

    @IBOutlet weak var nameTextField: UITextField!

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if nameTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty == true {
            let alert = UIAlertController(title: "Erreur", message: "Veuillez entrer un nom.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tabBarController = segue.destination as? UITabBarController {
            for childVC in tabBarController.viewControllers ?? [] {
                if let movieVC = childVC as? MovieViewController {
                    movieVC.userName = nameTextField.text
                    movieVC.context = self.context
                } else if let wordVC = childVC as? WordViewController {
                    wordVC.userName = nameTextField.text
                    wordVC.context = self.context
                }
            }
        }
    }
}
