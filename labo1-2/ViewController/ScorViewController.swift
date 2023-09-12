import UIKit
import CoreData

class ScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var movieScores: [Score] = []
    var wordScores: [Score] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup table view
        tableView.dataSource = self
        tableView.delegate = self

        fetchScores()
    }
    
    private func fetchScores() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        movieScores = Score.fetchTopScores(for: "Movie Title", limit: 5, context: context)
        wordScores = Score.fetchTopScores(for: "Dictionnary Word", limit: 5, context: context)

        tableView.reloadData()
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // One for Movie and one for Word
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Movie Title Scores" : "Dictionnary Word Scores"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? movieScores.count : wordScores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath)
        
        let score = indexPath.section == 0 ? movieScores[indexPath.row] : wordScores[indexPath.row]
        cell.textLabel?.text = "\(score.name) - \(score.value)"
        
        return cell
    }
}
