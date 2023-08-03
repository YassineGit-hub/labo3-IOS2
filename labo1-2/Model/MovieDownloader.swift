
import Foundation

struct Movie: Codable {
    let Title: String
}

struct MovieDownloader {
    let apiKey = "d30fb14f"
    let baseURL = "https://www.omdbapi.com/?apikey="

    func fetchMovie(imdbID: String, completion: @escaping (String) -> Void) {
        let urlString = "\(baseURL)\(apiKey)&i=\(imdbID)"
        let url = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let decoder = JSONDecoder()
                if let movie = try? decoder.decode(Movie.self, from: data) {
                    completion(movie.Title)
                }
            }
        }
        task.resume()
    }
}

let movieDownloader = MovieDownloader()


for imdbID in listeFilms {
    movieDownloader.fetchMovie(imdbID: imdbID) { title in
        print(title)
    }
}
