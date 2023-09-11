import Foundation
import CoreData

public class Score: NSManagedObject {
    @NSManaged public var name: String
    @NSManaged public var value: Int16
    @NSManaged public var gameType: String
}

extension Score {
    static func saveIfHighest(name: String, value: Int16, gameType: String, context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<Score>(entityName: "Score")
        fetchRequest.predicate = NSPredicate(format: "gameType == %@", gameType)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "value", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        do {
            let highestScores = try context.fetch(fetchRequest)
            
            if let highestScore = highestScores.first {
                if value > highestScore.value {
                    saveScore(name: name, value: value, gameType: gameType, context: context)
                }
            } else {
                saveScore(name: name, value: value, gameType: gameType, context: context)
            }
        } catch {
            print("Failed to fetch highest score: \(error)")
        }
    }
    
    private static func saveScore(name: String, value: Int16, gameType: String, context: NSManagedObjectContext) {
        let score = Score(context: context)
        score.name = name
        score.value = value
        score.gameType = gameType
        
        do {
            try context.save()
        } catch {
            print("Failed to save score: \(error)")
        }
    }
    
    static func fetchTopScores(for gameType: String, limit: Int = 5, context: NSManagedObjectContext) -> [Score] {
        let fetchRequest = NSFetchRequest<Score>(entityName: "Score")
        fetchRequest.predicate = NSPredicate(format: "gameType == %@", gameType)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "value", ascending: false)]
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
