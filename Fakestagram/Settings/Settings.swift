//
//  This file is for educational purposes only. It may contain code snippets, examples, images, and explanations
//  intended to help understand concepts and improve programming skills.
//

import Foundation

struct Settings {
    static var user: User? {
        get {
            try? UserDefaults.standard.get(for: "user")
        }
        set {
            try? UserDefaults.standard.set(object: newValue, for: "user")
        }
    }
    static var hideCaptions: Bool {
        get {
            UserDefaults.standard.bool(forKey: "hideCaption")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "hideCaption")
        }
    }
}
