import UIKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var devinetteLabel: UILabel!
    @IBOutlet weak var userInputField: UITextField!
    @IBOutlet weak var userUsedLetters: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var hangmanView: UIImageView!
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var firstDirectorLabel: UILabel!
    @IBOutlet weak var secondDirectorLabel: UILabel!
    @IBOutlet weak var firstActorLabel: UILabel!
    @IBOutlet weak var secondActorLabel: UILabel!
    @IBOutlet weak var thirdActorLabel: UILabel!

    let movieDownloader = MovieDownloader()
    var currentMovie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()

        movieDownloader.getRandomMovie { movie in
            guard let movie = movie else { return }
            self.currentMovie = movie
            JeuPendu.shared.jouer(avec: movie)

            DispatchQueue.main.async {
                self.devinetteLabel.text = JeuPendu.shared.devinette
                self.pointsLabel.text = JeuPendu.shared.erreurs
            }
        }
    }

    @IBAction func validateBtn(_ sender: Any) {
        if let userInput = userInputField.text, !userInput.isEmpty, let character = userInput.first {
            if character.isLetter {
                let lettre = String(character)
                JeuPendu.shared.verifier(lettre: lettre)

                devinetteLabel.text = JeuPendu.shared.devinette
                userInputField.text = ""
                userUsedLetters.text = JeuPendu.shared.lettresUtilisees

                updateMovieHintsBasedOnErrorCount()

                if let fin = JeuPendu.shared.verifierFinDePartie() {
                    let alert = UIAlertController(title: "Fin", message: "\(fin)", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default) { _ in
                        print("End of game")
                    }
                    alert.addAction(OKAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

    func updateMovieHintsBasedOnErrorCount() {
        let errorCountString = JeuPendu.shared.erreurs
        pointsLabel.text = errorCountString

        if let errorCount = Int(errorCountString) {
            switch errorCount {
            case 2:
                releaseYearLabel.text = JeuPendu.shared.hints
            case 4:
                ratingLabel.text = JeuPendu.shared.hints
                genreLabel.text = JeuPendu.shared.hints
            case 5:
                displayDirectorsAndActors()
            default:
                break
            }
        }
    }

    func displayDirectorsAndActors() {
        let hints = JeuPendu.shared.hints
        let hintsLines = hints.split(separator: "\n")
        
        if hintsLines.count >= 3 {
            let directorsLine = hintsLines[1]
            let actorsLine = hintsLines[2]
            let directors = directorsLine.replacingOccurrences(of: "Directors: ", with: "").split(separator: ",")
            let actors = actorsLine.replacingOccurrences(of: "Actors: ", with: "").split(separator: ",")

            firstDirectorLabel.text = directors.first?.trimmingCharacters(in: .whitespacesAndNewlines)
            if directors.count > 1 {
                secondDirectorLabel.text = directors[1].trimmingCharacters(in: .whitespacesAndNewlines)
            }

            firstActorLabel.text = actors.first?.trimmingCharacters(in: .whitespacesAndNewlines)
            if actors.count > 1 {
                secondActorLabel.text = actors[1].trimmingCharacters(in: .whitespacesAndNewlines)
            }
            if actors.count > 2 {
                thirdActorLabel.text = actors[2].trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
    }
}

