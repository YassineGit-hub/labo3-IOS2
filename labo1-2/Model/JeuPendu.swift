import Foundation
import UIKit

struct EndOfGameInformation {
    let win: Bool
    let title: String
    let cntErrors: Int
    var finalMessage: String {
        return """
        Win: \(win) in \(cntErrors)/7.
        Title was : \(title)
        """
    }
}

class JeuPendu {
    static let shared = JeuPendu()

    private init(){}

    private let maxErrors: Int = 7
    private var errorCount: Int = 0
    private var titleToGuess: [Character] = []
    private var foundIndices: [Bool] = []
    private var userLetters: [Character] = []
    private var movieToGuess: Movie?

    // Assuming that you have a file named ImagesSequenceData with a static variable imageNames
    private let imageNamesSequence = ImagesSequenceData.imageNames

    var guess: String {
        let arr = foundIndices.indices.map {foundIndices[$0] ? titleToGuess[$0] : "#"}
        return String(arr)
    }

    var usedLetters: String {
        return userLetters.map { String($0) }.joined(separator:", ")
    }

    var errors: String {
        return "\(errorCount) / \(maxErrors)"
    }

    var image : UIImage {
        return UIImage(named: imageNamesSequence[errorCount])!
    }

    func play(with movie: Movie) {
        movieToGuess = movie
        titleToGuess = Array(movie.Title)
        foundIndices = Array(repeating: false, count: titleToGuess.count)

        titleToGuess.enumerated().forEach { (idx, letter) in
            if !("abcdefghijklmnopqrstuvwxyz".contains(letter.lowercased())) {
                foundIndices[idx] = true
            }
        }
        print("DB : play()", guess)
        errorCount = 0
    }

    func verify(letter: Character) {
        userLetters.append(letter)
        var found = false

        titleToGuess.enumerated().forEach { (idx, mysteryLetter) in
            if mysteryLetter.lowercased() == letter.lowercased() {
                foundIndices[idx] = true
                found = true
            }
        }

        if !found {
            errorCount += 1
        }
    }

    func verifyEndOfGame() -> String? {
        if errorCount == maxErrors {
            return EndOfGameInformation(win: false, title: String(titleToGuess), cntErrors: errorCount).finalMessage
        } else if foundIndices.allSatisfy({$0}) {
            return EndOfGameInformation(win: true, title: String(titleToGuess), cntErrors: errorCount).finalMessage
        }
        return nil
    }
}
