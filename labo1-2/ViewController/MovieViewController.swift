import UIKit

class MovieViewController: UIViewController {

    // Outlets
    @IBOutlet weak var devinetteLabel: UILabel!
    @IBOutlet weak var userInputField: UITextField!
    @IBOutlet weak var userUsedLetters: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var directorsLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!

    // Variables
    let movieDownloader = MovieDownloader()
    var currentMovie: Movie?
    var userName: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        movieDownloader.getRandomMovie { movie in
            print("Downloaded movie: \(movie)")
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

        guard let errorCount = Int(errorCountString), let movie = currentMovie else {
            return
        }

        switch errorCount {
        case 2:
            releaseYearLabel.text = movie.Released ?? "Non disponible"
        case 4:
            ratingLabel.text = movie.Rated ?? "Non disponible"
            genreLabel.text = movie.Genre ?? "Non disponible"
        case 5:
            if let directors = movie.Director?.components(separatedBy: ",").prefix(2).joined(separator: ", ").trimmingCharacters(in: .whitespaces) {
                directorsLabel.text = directors
            } else {
                directorsLabel.text = "Non disponible"
            }

            if let actors = movie.Actors?.components(separatedBy: ",").prefix(3).joined(separator: ", ").trimmingCharacters(in: .whitespaces) {
                actorsLabel.text = actors
            } else {
                actorsLabel.text = "Non disponible"
            }
        default:
            releaseYearLabel.text = ""
            ratingLabel.text = ""
            genreLabel.text = ""
            directorsLabel.text = ""
            actorsLabel.text = ""
        }
    }

    func saveScore(score: Int) {
        let gameType = "Movie Title"
        let newScore = Score(name: userName ?? "defaultUser", value: score, gameType: gameType)
        Score.saveScore(newScore)
    }

}
