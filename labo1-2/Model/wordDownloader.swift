import Foundation

class WordDownloader {

    private let apiUrlString = "https://random-word-api.herokuapp.com/word"
    
    func fetchRandomWord(completion: @escaping (String?) -> Void) {
        guard let url = URL(string: apiUrlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                do {
                    if let words = try JSONSerialization.jsonObject(with: data, options: []) as? [String], let word = words.first {
                        completion(word)
                    } else {
                        completion(nil)
                    }
                } catch {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
}

