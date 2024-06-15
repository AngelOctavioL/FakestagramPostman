//
//  This file is for educational purposes only. It may contain code snippets, examples, images, and explanations
//  intended to help understand concepts and improve programming skills.
//

import Foundation

import Foundation

class PostsModel {
    var posts: [Post]?
    
    func post(for index: Int) -> Post? {
        posts?[index]
    }
    
    func getNumberOfPosts() -> Int {
        posts?.count ?? 0
    }
}

extension PostsModel {
    func getPosts(userID: Int, completionHandler: @escaping (Error?) -> Void) {
        guard let request = buildRequest(byQuery: true, userID: userID) else {
            completionHandler(UserModelError.badRequest)
            return
        }
        
        // ocupando singleton
        // weak self -> para decirle que la referencia a la otra clase es una referencia debil
        let task = URLSession.shared.dataTask(with: request) { [weak self]
            data, response, error in
            if let error {
                completionHandler(error)
            } else {
                guard let httpResponse = (response as? HTTPURLResponse) else {
                    completionHandler(UserModelError.unexpectedResponse)
                    return
                }
                guard httpResponse.statusCode == 200 else {
                    completionHandler(UserModelError.badResponse(httpResponse.statusCode))
                    return
                }
                do {
                    guard let data else {
                        completionHandler(UserModelError.userNotFound)
                        return
                    }
                    let PostsDTO = try [PostsDTO](data:data)
                    self?.posts = PostsDTO.map{
                        post in Post(title: post.title, body: post.body)
                    }
                    completionHandler(nil)
                } catch {
                    completionHandler(error)
                }
            }
        }
        task.resume()
    }
    
    func buildRequest(byQuery: Bool, userID: Int) -> URLRequest? {
    //https://jsonplaceholder.typicode.com/users/1/posts?_page=1&_limit=10
        var components = URLComponents()
        components.scheme = "https"
        components.host = "jsonplaceholder.typicode.com"
        components.queryItems = [
            URLQueryItem(name: "_page", value: "1"),
            URLQueryItem(name: "_limit", value: "10")
        ]
        if byQuery {
            components.path = "/posts"
            components.queryItems?.append(URLQueryItem(name: "userId", value: "\(userID)"))
        } else {
            components.path = "/users/\(userID)/posts"
        }
        guard let url = components.url else { return nil }
        return URLRequest(url: url)
    }
}
