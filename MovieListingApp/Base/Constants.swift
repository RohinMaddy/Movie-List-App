//
//  Constants.swift
//  MovieListingApp
//
//  Created by Rohin Madhavan on 28/01/2023.
//

import Foundation

struct Constants {
    //Alert messages
    static let alertOkMessage = "OK"
    static let alertDefaultMessage = "Default"
    static let alertCancelMessage = "Cancel"
    static let alertErrorMessage = "Error"
    static let alertDestructiveMessage = "Destructive"
    static let alertMovieErrorMessage = "Unable to fetch movie information"
    static let alertLoginErrorMessage = "There was an error!"
    static let alertLoginSuccessMessage = "User was sucessfully logged in."
    static let alertRegisterSuccessMessage = "User was sucessfully Registered."
    static let alertMessage = "Alert!"
    static let alertBiometricFailedMessage = "Biometric Authentication failed"
    static let alertNoBiometricMessage = "No biometric available"
    
    //Identifiers
    static let appName = "Movie Listing App"
    static let logoutTitle = "Logout"
    static let cellIdentifier = "searchCell"
    static let main = "Main"
    static let movieVcIdentifier = "MovieViewController"
    static let loginVcIdentifier = "LoginViewController"
    static let registerVcIdentifier = "RegisterViewController"
    static let switchStateKey = "FaceIdSwitchState"
    static let biometricDescription = "Required Face ID if the user is already logged in"
    
    //API URL and Keys
    static let searchUrl = "https://www.omdbapi.com/?s=love&apikey=81b3ef2b&type=movie&page="
    static let searchKey = "Search"
    static let titleKey = "Title"
    static let posterKey = "Poster"
    static let typeKey = "Type"
    static let imdbIdKey = "imdbID"
    static let yearKey = "Year"
}
