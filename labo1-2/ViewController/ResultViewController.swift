import UIKit

class ResultViewController: UIViewController {
    var finalMessage: String?

    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = finalMessage
    }
}



