import UIKit
import CoreData

class MovieViewController: UIViewController {
    
    @IBOutlet weak var devinetteLabel: UILabel!
    @IBOutlet weak var userInputField: UITextField!
    @IBOutlet weak var userUsedLetters: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var directorsLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    
    var context: NSManagedObjectContext?
    var userName: String?
    
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
                    navigateToResultViewController(withResult: fin)
                    saveScore(score: JeuPendu.shared.currentScore())
                }
            }
        }
    }
    @IBAction func restartGame(_ sender: Any) {
        JeuPendu.shared.recommencerJeu()
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

    

    func navigateToResultViewController(withResult result: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let resultVC = storyboard.instantiateViewController(withIdentifier: "ResultViewControllerID") as? ResultViewController {
            resultVC.finalMessage = result
            navigationController?.pushViewController(resultVC, animated: true)
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
            releaseYearLabel.text = movie.Released
        case 4:
            ratingLabel.text = movie.Rated
            genreLabel.text = movie.Genre
        case 5:
            directorsLabel.text = movie.Director?.components(separatedBy: ",").prefix(2).joined(separator: ", ")
            actorsLabel.text = movie.Actors?.components(separatedBy: ",").prefix(3).joined(separator: ", ")
        default:
            releaseYearLabel.text = ""
            ratingLabel.text = ""
            genreLabel.text = ""
            directorsLabel.text = ""
            actorsLabel.text = ""
        }
    }

    func saveScore(score: Int) {
        guard let name = userName, let context = context else { return }
        Score.saveIfHighest(name: name, value: Int16(score), gameType: "Movie Title", context: context)
    }
    

}

