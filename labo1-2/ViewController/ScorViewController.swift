
import UIKit

class ScoreViewController: UIViewController {

    @IBOutlet weak var bestScoreLabel: UILabel!
    @IBOutlet weak var bestPlayerLabel: UILabel!
    @IBOutlet weak var gameTypeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadBestScore()
    }

    private func loadBestScore() {
        if let bestScore = Score.loadSavedScore() {
            bestScoreLabel.text = "Meilleur score: \(bestScore.value)"
            bestPlayerLabel.text = "Joueur: \(bestScore.name)"
            gameTypeLabel.text = "Type de jeu: \(bestScore.gameType)"
        } else {
            bestScoreLabel.text = "Meilleur score: -"
            bestPlayerLabel.text = "Joueur: -"
            gameTypeLabel.text = "Type de jeu: -"
        }
    }
}
