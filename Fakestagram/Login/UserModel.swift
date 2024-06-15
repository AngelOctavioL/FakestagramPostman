//
//  This file is for educational purposes only. It may contain code snippets, examples, images, and explanations
//  intended to help understand concepts and improve programming skills.
//

import Foundation

class UserModel {
    static var holi: String { return "holis" }
    var user: User? {
        didSet {
            Settings.user = user
        }
    }
}

enum UserModelError: Error, LocalizedError {
    case userNotFound, parsingError, fileError, badRequest, unexpectedResponse, invalidUser
    case badResponse(Int)
    
    var errorDescription: String? {
        switch self {
        case .fileError: return "Could not read from file"
        case .userNotFound: return "User not found"
        case .parsingError: return "Could not parse response"
        case .badRequest: return "The request could not be built."
        case .badResponse(let code): return "HTTP response \(code)"
        case .unexpectedResponse: return "Could not interpret response."
        case .invalidUser: return "Your user information is incomplete, please log in from our website to complete it. "
        }
    
    }
}

extension UserModel {
    func saveUser(from dto: UserDTO) throws {
        guard let id = dto.id, let name = dto.name, let email = dto.email, let username = dto.username else { throw UserModelError.invalidUser }
        user = User(id: id, name: name, username: username, email: email)
    }
    
    func findUser(email: String, completionHandler: @escaping (Error?) -> Void) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users?email=Shanna@melissa.tv") else {
            completionHandler(UserModelError.badRequest)
            return
        }
        
        // ocupando singleton
        // weak self -> para decirle que la referencia a la otra clase es una referencia debil
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self]
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
                    guard let data,
                          let UserDTO = (try [UserDTO](data:data)).first else {
                        completionHandler(UserModelError.userNotFound)
                        return
                    }
                    try self?.saveUser(from: UserDTO)
                    completionHandler(nil)
                } catch {
                    completionHandler(error)
                }
            }
        }
        task.resume()
    }
}


