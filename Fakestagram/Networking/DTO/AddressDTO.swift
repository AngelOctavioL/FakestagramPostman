//
//  This file is for educational purposes only. It may contain code snippets, examples, images, and explanations
//  intended to help understand concepts and improve programming skills.
//

import Foundation

struct AddressDTO: Decodable {
    var city: String?
    var street: String?
    
    private enum CodingKeys: String, CodingKey {
        case city = "cityOfResidence"
        case street
    }
}
