import Foundation
import CoreData

public class Score: NSManagedObject {
    @NSManaged public var username: String
    @NSManaged public var score: Int16
    @NSManaged public var gameType: String
}

extension Score {
    
    static func save(name: String, value: Int16, gameType: String, context: NSManagedObjectContext) {
        let newScore = Score(context: context)
        newScore.username = name
        newScore.score = value
        newScore.gameType = gameType
        
        do {
            try context.save()
        } catch {
            print("Failed to save new score: \(error)")
        }
    }

    static func saveIfHighest(name: String, value: Int16, gameType: String, context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<Score>(entityName: "Score")
        fetchRequest.predicate = NSPredicate(format: "gameType == %@", gameType)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "score", ascending: true)]
        
        do {
            let allScores = try context.fetch(fetchRequest)
            
            if allScores.count < 5 {
                save(name: name, value: value, gameType: gameType, context: context)
            } else if let lowestScore = allScores.first, value > lowestScore.score {
                context.delete(lowestScore)
                save(name: name, value: value, gameType: gameType, context: context)
            }
        } catch {
            print("Failed to fetch scores: \(error)")
        }
    }

    static func fetchTopScores(for gameType: String, limit: Int = 5, context: NSManagedObjectContext) -> [Score] {
        let fetchRequest = NSFetchRequest<Score>(entityName: "Score")
        fetchRequest.predicate = NSPredicate(format: "gameType == %@", gameType)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "score", ascending: false)]
        fetchRequest.fetchLimit = limit
        
        do {
            let scores = try context.fetch(fetchRequest)
            return scores
        } catch {
            print("Failed to fetch top scores: \(error)")
            return []
        }
    }
}

