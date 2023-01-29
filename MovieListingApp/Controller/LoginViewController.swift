//
//  LoginViewController.swift
//  MovieListingApp
//
//  Created by Rohin Madhavan on 28/01/2023.
//

import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    

    @IBAction func didPressLoginButton(_ sender: UIButton) {
        let loginManager = FirebaseAuthenticationManager()
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        loginManager.signIn(email: email, pass: password) {[weak self] (success) in
            guard let `self` = self else { return }
            var message: String = ""
            if (success) {
                message = Constants.alertLoginSuccessMessage
                let vc = UIStoryboard.init(name: Constants.main, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.movieVcIdentifier) as? MovieViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
            } else {
                message = Constants.alertLoginErrorMessage
            }
            self.showAlert(message: message, title: Constants.alertMessage)
        }
    }
}
