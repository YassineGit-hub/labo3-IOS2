import Foundation

struct Movie: Codable {
    let Title: String
}

struct MovieDownloader {
    let apiKey = "d30fb14f"
    let baseURL = "https://www.omdbapi.com/?apikey="

    func downloadMovie(withID id: String, completion: @escaping (Movie?) -> ()) {
        let urlString = "\(baseURL)\(apiKey)&i=\(id)"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data, error == nil else {
                print("Erreur lors du téléchargement du film")
                completion(nil)
                return
            }
            let decoder = JSONDecoder()
            if let movie = try? decoder.decode(Movie.self, from: data) {
                completion(movie)
            } else {
                print("Erreur lors de la décomposition du film")
                completion(nil)
            }
        }.resume()
    }
}

let movieDownloader = MovieDownloader()

