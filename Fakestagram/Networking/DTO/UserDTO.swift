//
//  This file is for educational purposes only. It may contain code snippets, examples, images, and explanations
//  intended to help understand concepts and improve programming skills.
//

import Foundation

struct UserDTO: Decodable {
    var id: Int?
    var name: String?
    var username: String?
    var email: String?
    var address: AddressDTO?
}

// Codable = Decodable + Encodable
