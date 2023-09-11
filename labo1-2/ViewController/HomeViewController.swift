import UIKit
import CoreData


class HomeViewController: UIViewController {
    var context: NSManagedObjectContext?

    
    @IBOutlet weak var nameTextField: UITextField!
    
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
