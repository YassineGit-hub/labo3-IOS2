import Foundation

class JeuPenduDictionnary {

    private var wordToGuess: String = ""
    private var currentWordState: [Character] = []
    private var errorsCount: Int = 0
    private var guessedLetters: [Character] = []

    private let wordDownloader = WordDownloader()
    private let maxScore = 100

    func startNewGame(completion: @escaping (Bool) -> Void) {
        wordDownloader.fetchRandomWord { [weak self] word in
            guard let self = self, let word = word else {
                completion(false)
                return
            }
            self.initializeGame(with: word)
            print("Mot à deviner: \(word)")
            completion(true)
        }
    }

    private func initializeGame(with word: String) {
        self.wordToGuess = word
        self.currentWordState = Array(repeating: "#", count: word.count)
        self.errorsCount = 0
        self.guessedLetters = []
    }

    func getWordToGuess() -> String {
        return wordToGuess
    }

    func guessLetter(_ letter: Character) {
        if !guessedLetters.contains(letter) {
            guessedLetters.append(letter)
            if wordToGuess.contains(letter) {
                for (index, wordLetter) in wordToGuess.enumerated() {
                    if wordLetter == letter {
                        currentWordState[index] = letter
                    }
                }
            } else {
                errorsCount += 1
            }
        }
    }

    func getCurrentState() -> String {
        return String(currentWordState)
    }

    func getErrorsCount() -> Int {
        return errorsCount
    }

    func getGuessedLetters() -> String {
        return String(guessedLetters)
    }

    func hasGameEnded() -> Bool {
        return errorsCount >= 6 || !currentWordState.contains("#")
    }

    func getFinalScore() -> Int {
        let deductionPerError = maxScore / 6 // 6 est le nombre d'erreurs maximum
        return maxScore - (errorsCount * deductionPerError)
    }
    func recommencerJeu(completion: @escaping (Bool) -> Void) {
        startNewGame(completion: completion)
    }

}
