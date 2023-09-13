import Foundation

struct EndOfGameInformation {
    let win: Bool
    let title: String
    let cntErrors: Int
    var finalMessage: String {
        if win {
            return "gagné!"
        } else {
            return "perdu!\nLe titre est : \(title)"
        }
    }
}

class JeuPendu {
    static let shared = JeuPendu()
    
    private init() {}
    
    private let maxErreur: Int = 6
    private let maxScore: Int = 100 // Added maxScore
    private var nbErreurs: Int = 0
    private var titreADeviner: [Character] = []
    private var indexTrouves: [Bool] = []
    private var lettresUtilisateurs: [Character] = []
    var filmADeviner: Movie?
    
    var devinette: String {
        let arr = indexTrouves.indices.map { indexTrouves[$0] ? titreADeviner[$0] : "#"}
        return String(arr)
    }
    
    var lettresUtilisees: String {
        return lettresUtilisateurs.map { String($0) }.joined(separator:", ")
    }
    
    var erreurs: String {
        return "\(nbErreurs) / \(maxErreur)"
    }
    
    var hints: String {
        var result = ""
        if let film = filmADeviner {
            switch nbErreurs {
            case 2:
                if let releaseDate = film.Released {
                    result += "Release Year: \(releaseDate)"
                }
            case 4:
                if let genre = film.Genre {
                    result += "Genre: \(genre) "
                }
                if let rated = film.Rated {
                    result += "Rated: \(rated) "
                }
            case 5:
                let directors = film.Director?.split(separator: ",").prefix(2) ?? []
                let actors = film.Actors?.split(separator: ",").prefix(3) ?? []
                result += "Directors: \(directors.joined(separator: ", ")) "
                result += "Actors: \(actors.joined(separator: ", "))"
            default:
                break
            }
        }
        return result
    }
    
    func jouer(avec film: Movie) {
        filmADeviner = film
        print("Titre du film actuel: \(film.Title)")
        titreADeviner = Array(film.Title)
        indexTrouves = Array(repeating: false, count: titreADeviner.count)
        
        titreADeviner.enumerated().forEach { (idx, lettre) in
            if !("abcdefghijklmnopqrstuvwxyz".contains(lettre.lowercased())) {
                indexTrouves[idx] = true
            }
        }
        nbErreurs = 0
    }
    
    func verifier(lettre: String) {
        if let character = lettre.first, character.isLetter {
            let characterLowercased = character.lowercased()
            if let firstLowercasedChar = characterLowercased.first {
                lettresUtilisateurs.append(firstLowercasedChar)
                var trouvee = false
                
                titreADeviner.enumerated().forEach { (idx, lettreMystere) in
                    if lettreMystere.lowercased() == characterLowercased {
                        indexTrouves[idx] = true
                        trouvee = true
                    }
                }
                
                if !trouvee {
                    nbErreurs += 1
                }
            }
        }
    }
    
    func verifierFinDePartie() -> String? {
        if nbErreurs == maxErreur {
            return EndOfGameInformation(win: false, title: String(titreADeviner), cntErrors: nbErreurs).finalMessage
        } else if indexTrouves.allSatisfy({$0}) {
            return EndOfGameInformation(win: true, title: String(titreADeviner), cntErrors: nbErreurs).finalMessage
        }
        return nil
    }
    
    func currentMovie() -> Movie? {
        return filmADeviner
    }
    
    func currentScore() -> Int {
        return maxScore - (nbErreurs * maxScore / maxErreur) // Updated score calculation
    }
    
    func recommencerJeu() {
        nbErreurs = 0
        titreADeviner = []
        indexTrouves = []
        lettresUtilisateurs = []
        filmADeviner = nil
    }
}

