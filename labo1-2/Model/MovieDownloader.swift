import Foundation

 

struct Movie: Codable {
    let Title: String


}

 

struct MovieDownloader {
    let apiKey = "7e05242e"
    let baseURL = "https://www.omdbapi.com/?apikey="

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

            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON Response: \(jsonString)")
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

 

}

 

let movieDownloader = MovieDownloader()

 
