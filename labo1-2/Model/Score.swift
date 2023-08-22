// Score.swift
import Foundation

struct Score: Codable {
    var name: String
    var value: Int
    var gameType: String
}

extension Score {
    static let savedKey = "savedScore"

    static func saveScore(_ score: Score) {
        if let encodedScore = try? JSONEncoder().encode(score) {
            UserDefaults.standard.set(encodedScore, forKey: Score.savedKey)
        }
    }

    static func loadSavedScore() -> Score? {
        if let savedScoreData = UserDefaults.standard.data(forKey: Score.savedKey),
           let decodedScore = try? JSONDecoder().decode(Score.self, from: savedScoreData) {
            return decodedScore
        }
        return nil
    }
}

