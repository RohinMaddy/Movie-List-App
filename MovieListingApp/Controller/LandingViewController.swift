//
//  LandingViewController.swift
//  MovieListingApp
//
//  Created by Rohin Madhavan on 28/01/2023.
//

import UIKit
import FirebaseAuth
import LocalAuthentication

class LandingViewController: BaseViewController {

    @IBOutlet weak var faceIdSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        faceIdSwitch.isOn = UserDefaults.standard.bool(forKey: Constants.switchStateKey)
        checkUserSignedInStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    
    
    @IBAction func valueChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: Constants.switchStateKey)
    }

    @IBAction func didPressLoginButton(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: Constants.main, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.loginVcIdentifier) as? LoginViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func didPressRegisterButton(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: Constants.main, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.registerVcIdentifier) as? RegisterViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func checkUserSignedInStatus() {
        if Auth.auth().currentUser != nil {
            if faceIdSwitch.isOn {
                useFaceID()
            } else {
                let vc = UIStoryboard.init(name: Constants.main, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.movieVcIdentifier) as? MovieViewController
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
    }
    
    func useFaceID() {
        let context = LAContext()
            var error: NSError?

            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let description = Constants.biometricDescription

                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: description) {
                    [weak self] success, authenticationError in

                    DispatchQueue.main.async {
                        if success {
                            let vc = UIStoryboard.init(name: Constants.main, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.movieVcIdentifier) as? MovieViewController
                            self?.navigationController?.pushViewController(vc!, animated: true)
                        } else {
                            self?.showAlert(message: Constants.alertErrorMessage, title: Constants.alertBiometricFailedMessage)
                        }
                    }
                }
            } else {
                showAlert(message: Constants.alertErrorMessage, title: Constants.alertNoBiometricMessage)
            }
    }
}
