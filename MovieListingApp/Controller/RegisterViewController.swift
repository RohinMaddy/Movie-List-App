//
//  RegisterViewController.swift
//  MovieListingApp
//
//  Created by Rohin Madhavan on 28/01/2023.
//

import UIKit

class RegisterViewController: BaseViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    
    @IBAction func didPressRegisterButton(_ sender: UIButton) {
        let signUpManager = FirebaseAuthenticationManager()
            if let email = emailTextField.text, let password = passwordTextField.text {
                signUpManager.createUser(email: email, password: password) {[weak self] (success) in
                    guard self != nil else { return }
                    var message: String = ""
                    if (success) {
                        message = Constants.alertRegisterSuccessMessage
                        let vc = UIStoryboard.init(name: Constants.main, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.movieVcIdentifier) as? MovieViewController
                        self?.navigationController?.pushViewController(vc!, animated: true)
                    } else {
                        message = Constants.alertLoginErrorMessage
                    }
                    self?.showAlert(message: message, title: Constants.alertMessage)
                }
            }
    }
}
