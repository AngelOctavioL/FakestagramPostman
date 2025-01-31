//
//  This file is for educational purposes only. It may contain code snippets, examples, images, and explanations
//  intended to help understand concepts and improve programming skills.
//

import UIKit

class LoginViewController: UIViewController {
    var userModel = UserModel()
    var customView: LoginView {
        return view as! LoginView
    }
    private weak var router: MainRouter?
    
    init(router: MainRouter? = nil) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = LoginView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewConnections()
    }

    private func loginViewConnections() {
        customView.loginButton.addAction(UIAction(handler: attemtpLocalLogin(_:)), for: .touchUpInside)
    }
    
    private func userNameValidation() -> Bool {
        customView.usernameTextfield.text?.isEmpty ?? false
    }
    
    private func logIn() {
        router?.logIn()
    }
    
}

// MARK: - local
extension LoginViewController {
    func attemtpLocalLogin(_ sender: UIAction) {
        if let email = customView.usernameTextfield.text, !email.isEmpty {
            userModel.findUser(email: email) { [weak self] error in
                if let error {
                    // para regresarle el control a main
                    DispatchQueue.main.async {
                        self?.presentErrorAlert(title: "Error", message: error.localizedDescription)
                    }
                    self?.presentErrorAlert(title: "Error", message: error.localizedDescription)
                } else {
                    self?.logIn()
                }
            }
        } else {
            presentErrorAlert(title: "Error", message: "Please enter your email.")
        }
    }
}
