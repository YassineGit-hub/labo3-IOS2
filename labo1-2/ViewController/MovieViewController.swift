//
//  MovieViewController.swift
//  labo2-IOS2
//
//  Created by Yassine Belkaousse (Étudiant) on 2023-08-20.
//

import UIKit

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

    let movieDownloader = MovieDownloader()
    var currentMovie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()

        movieDownloader.getRandomMovie { movie in
            print("Downloaded movie: \(movie)");
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
            print("Guard statement in updateMovieHintsBasedOnErrorCount failed")
            return
        }
    
        print("Error count: \(errorCount)")
    
        switch errorCount {
        case 2:
            print("Released: \(movie.Released ?? "No data")")
            releaseYearLabel.text = movie.Released
        
        case 4:
            print("Rated: \(movie.Rated ?? "No data")")
            print("Genre: \(movie.Genre ?? "No data")")
            ratingLabel.text = movie.Rated
            genreLabel.text = movie.Genre
        
        case 5:
            print("Director: \(movie.Director ?? "No data")")
            print("Actors: \(movie.Actors ?? "No data")")
            directorsLabel.text = movie.Director?.components(separatedBy: ",").prefix(2).joined(separator: ", ")
            actorsLabel.text = movie.Actors?.components(separatedBy: ",").prefix(3).joined(separator: ", ").trimmingCharacters(in: .whitespaces)
        
        default:
            break
        }
    }
}


