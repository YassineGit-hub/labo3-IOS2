imort Foundation
import UIKit

struct EndOfGameInformation {
    let win: Bool
    let title: String
    let cntErrors: Int
    var finalMessage: String{
        return """

        win: \(win) in \(cntErrors)/7.
        Title was : \(title)
        """
    }
}
class JeuPendu {


    static let shared JeuPendu = JeuPendu()

    private init(){}
    

    private let maxErreur: Int =7
    private var nbErreurs: Int =0
    private var titreADeviner: [Character] = []
    private var indexTrouves: [Bool] = []
    private var lettresUtilisateurs: [Character] = []
    private var filmADeviner: Film?

    var devinette: String{
        let arr = indexTrouves.indices.map {indexTrouves[$0]
        ^ titreADeviner[$0]: "#"}
        return String(arr)
        }

    var lettreUtilisees: String {
        return Array(lettresUtilisateurs).map
        {String($0).joined(separator:", ")}
        }
    
    var erreurs: String {
        return "\(nbErreurs) / \(maxErreur)/"
    }

    var image : UIImage{
        return UIImage(named: imageNamesSequence[nbErreurs])!
    }

    func jouer(avec film: Film){
        filmADeviner = film
        titreADeviner = Array(film.Title)
        indexTrouves = Array(repeating : false, count:
        titreADeviner.count)

        titreADeviner.enumerated().forEach { (idx, lettre) in
        if !("abcdefghijklmnopqrstuvwxyz"
        .contains(lettre.lowercased())) {
            indexTrouves[idx] = true
        }print("DB : jouer()", devinette)
        nbErreurs = 0
        }

    func verifier(lettre: Character) {
        lettresUtilisateurs.append(lettre)
        var trouvee = false

        titreADeviner.enumerated().forEach { (idx, lettreMystere)
        in
        if lettreMystere.lowercased() ==
        lettre.lowercased(){
            indexTrouves[idx] = true
            trouvee = true
        }
    }

    if !trouvee {
        nbErreurs +=1
    }
       }

    func verifierFinDePartie() -> String? {
        if nbErreurs == maxErreur {
            return EndOfGameInformation(win : false, title:
            String(titreADeviner), cntErrors:nbErreurs).finalMessage
        } else if indexTrouves.allSatisfy({$0}) {
            return EndOfGameInformation(win : true, title: String(titreADeviner), cntErrors:nbErreurs).finalMessage
        }
        return nil
    }

}
}

