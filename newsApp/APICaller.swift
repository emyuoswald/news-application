//
//  APICaller.swift
//  newsApp
//
//  Created by Дарья Локтева on 10.12.2022.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    struct Constatnts{
        static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=d73b5f3a1f504aca8749c90000ac1fed")
    }
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constatnts.topHeadlinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Статьи: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}

struct APIResponse: Decodable {
    let articles: [Article]
}

struct Article: Decodable {
       let source: Source?
       let title: String?
       let articleDescription: String?
       let url: String?
       let urlToImage: String?
       let publishedAt, content: String?
    
    enum CodingKeys: String, CodingKey {
            case source, title
            case articleDescription = "description"
            case url, urlToImage, publishedAt, content
        }
}

enum Author: String, Decodable {
    case bbcNews = "BBC News"
    case bbcSport = "BBC Sport"
}
struct Source: Decodable {
    let name: Author
}
