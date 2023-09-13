import UIKit
import CoreData

class ScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var movieScores: [Score] = []
    var wordScores: [Score] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ScoreViewController did load.")
        
        // Setup table view
        tableView.dataSource = self
        tableView.delegate = self

        fetchScores()
    }
    
    private func fetchScores() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        print("Starting to fetch scores...")

        movieScores = Score.fetchTopScores(for: "Movie Title", limit: 5, context: context)
        wordScores = Score.fetchTopScores(for: "Dictionnary Word", limit: 5, context: context)
        
        print("Fetched scores for Movie Title: \(movieScores.map { "\($0.username) - \($0.score)" }.joined(separator: ", "))")
        print("Fetched scores for Dictionnary Word: \(wordScores.map { "\($0.username) - \($0.score)" }.joined(separator: ", "))")

        tableView.reloadData()
        print("Finished fetching scores.")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("numberOfSections called.")
        let sections = 2
        print("Number of sections: \(sections)")
        return sections
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = section == 0 ? "Movie Title Scores" : "Dictionnary Word Scores"
        print("Title for section \(section): \(title)")
        return title
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowCount = section == 0 ? movieScores.count : wordScores.count
        print("Number of rows in section \(section): \(rowCount)")
        return rowCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Configuring cell for indexPath \(indexPath).")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath)
        
        let score = indexPath.section == 0 ? movieScores[indexPath.row] : wordScores[indexPath.row]
        print("Configuring cell for indexPath \(indexPath): \(score.username) - \(score.score)")
        
        cell.textLabel?.text = "\(score.username) - \(score.score)"
        return cell
    }
}
