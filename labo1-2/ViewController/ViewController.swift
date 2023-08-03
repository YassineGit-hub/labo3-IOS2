import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var devinetteLabel: UILabel!
    @IBOutlet weak var userInputField: UITextField!
    @IBOutlet weak var userUsedLetters: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var hangmanView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        movieDownloader.downloadMovie(withID: listeFilms.randomElement()!) { movie in
            guard let movie = movie else { return }
            JeuPendu.shared.jouer(avec: movie)

            DispatchQueue.main.async {
                self.devinetteLabel.text = JeuPendu.shared.devinette
                self.pointsLabel.text = "Pointage: \(JeuPendu.shared.erreurs)"
            }
        }
    }


    @IBAction func validateBtn(_ sender: Any) {
        guard let res = userInputField.text, res.count == 1, let character = res.first else { return }
        JeuPendu.shared.verifier(lettre: character)

        devinetteLabel.text = JeuPendu.shared.devinette
        userInputField.text = ""
        userUsedLetters.text = JeuPendu.shared.lettresUtilisees
        pointsLabel.text = "Erreurs: \(JeuPendu.shared.erreurs)"
        hangmanView.image = JeuPendu.shared.image

        if let fin = JeuPendu.shared.verifierFinDePartie() {
            print("DB gagne: ", fin)

            let alert = UIAlertController(title: "Fin", message: "\(fin)", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { _ in
                print("End of game")
            }
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
