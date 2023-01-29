//
//  FirebaseAuthenticationManager.swift
//  MovieListingApp
//
//  Created by Rohin Madhavan on 27/01/2023.
//

import Foundation
import FirebaseAuth

class FirebaseAuthenticationManager {
    
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let user = authResult?.user {
                print(user)
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        }
    }
    
    func signIn(email: String, pass: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { [weak self] authResult, error in
            if error != nil {
                        completionBlock(false)
                    } else {
                        completionBlock(true)
                    }
        }
    }
}
