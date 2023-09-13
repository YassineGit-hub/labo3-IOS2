import Foundation
import CoreData

public class Score: NSManagedObject {
    @NSManaged public var username: String
    @NSManaged public var score: Int16
    @NSManaged public var gameType: String
}

extension Score {
    static func saveIfHighest(name: String, value: Int16, gameType: String, context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<Score>(entityName: "Score")
        fetchRequest.predicate = NSPredicate(format: "gameType == %@", gameType)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "score", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        do {
            let highestScores = try context.fetch(fetchRequest)
            
            if let highestScore = highestScores.first {
                if value > highestScore.score {
                    save(name: name, value: value, gameType: gameType, context: context)
                }
            } else {
                save(name: name, value: value, gameType: gameType, context: context)
            }
        } catch {
            print("Failed to fetch highest score: \(error)")
        }
    }
    
    private static func save(name: String, value: Int16, gameType: String, context: NSManagedObjectContext) {
        let newScore = Score(context: context)
        newScore.username = name
        newScore.score = value
        newScore.gameType = gameType
        
        do {
            try context.save()
            print("Saved new score: \(name) - \(value) for game type: \(gameType)")
        } catch {
            print("Failed to save score: \(error)")
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
