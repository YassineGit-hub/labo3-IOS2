import Foundation

struct Movie: Codable {
    let Title: String
    let Released: String?
    let Genre: String?
    let Director: String?
    let Actors: String?
    let Rated: String? // Le champ "Rating" est souvent nommé "imdbRating" dans les API, mais vérifiez selon votre source de données.
}

struct MovieDownloader {
    let apiKey = "7e05242e"
    let baseURL = "https://www.omdbapi.com/?apikey="

    func generateRandomMovieID() -> String {
        let randomValue = Int.random(in: 1...55252)
        return String(format: "tt%07d", randomValue)
    }

    func downloadMovie(withID id: String, completion: @escaping (Movie?) -> ()) {
        let urlString = "\(baseURL)\(apiKey)&i=\(id)"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data, error == nil else {
                print("Error downloading the movie")
                completion(nil)
                return
            }

            let decoder = JSONDecoder()
            do {
                let movie = try decoder.decode(Movie.self, from: data)
                completion(movie)
            } catch let error {
                print("Error decoding the movie: \(error)")
                completion(nil)
            }

        }.resume()
    }

    func getRandomMovie(completion: @escaping (Movie?) -> ()) {
        let randomID = generateRandomMovieID()
        downloadMovie(withID: randomID, completion: completion)
    }
}

