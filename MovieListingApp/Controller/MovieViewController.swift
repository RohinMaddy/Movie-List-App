//
//  ViewController.swift
//  MovieListingApp
//
//  Created by Rohin Madhavan on 27/01/2023.
//

import UIKit
import FirebaseAuth

class MovieViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    private var search = [Search]()
    private var searchList = [Search]()
    
    var page = 1
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setupNavigationBar()
        getMovies()
    }
    
    func setupNavigationBar() {
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.black
        self.navigationItem.title = Constants.appName
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        let logoutBarButtonItem = UIBarButtonItem(title: Constants.logoutTitle, style: .done, target: self, action: #selector(logoutUser))
        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
        self.navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    @objc func logoutUser(){
         do {
             try Auth.auth().signOut()
             navigationController?.popToRootViewController(animated: true)
         } catch let error {
             showAlert(message: Constants.alertErrorMessage, title: error.localizedDescription)
         }
    }
    
    func filterAndSortSearchResults() {
        searchList = searchList.filter { item in
            if let year = Int(item.year){
                return year >= 2000
            } else {
                return false
            }
        }
        searchList = searchList.sorted { $0.year < $1.year }
    }
    
    func loadMoreData() {
            if !self.isLoading {
                self.isLoading = true
                DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) { //
                    self.getMovies()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.isLoading = false
                    }
                }
            }
        }

}

extension MovieViewController {
    
    func getMovies() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        guard let searchUrl = URL(string:Constants.searchUrl+"\(page)") else {
            return
        }
     
        let request = URLRequest(url: searchUrl)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print(error)
                self.showAlert(message: Constants.alertMovieErrorMessage, title: Constants.alertErrorMessage)
                return
            }
     
            if let data = data {
                self.search = self.parseJsonData(data: data)
     
                OperationQueue.main.addOperation({
                    self.searchList.append(contentsOf: self.search)
                    self.filterAndSortSearchResults()
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                })
            }
        })
     
        task.resume()
    }
     
    func parseJsonData(data: Data) -> [Search] {
     
        var searchList = [Search]()
     
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary

            let jsonResults = jsonResult?[Constants.searchKey] as! [AnyObject]
            for item in jsonResults {
                var search = Search()
                search.title = item[Constants.titleKey] as! String
                search.year = item[Constants.yearKey] as! String
                search.poster = item[Constants.posterKey] as! String
                search.imdbID = item[Constants.imdbIdKey] as! String
                search.type = item[Constants.typeKey] as! String
                searchList.append(search)
            }
     
        } catch {
            print(error)
        }
     
        return searchList
    }
}

extension MovieViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier) as! MovieTableViewCell
        cell.movieTitleLabel.text = searchList[indexPath.row].title
        cell.movieYearLabel.text = searchList[indexPath.row].year
        cell.typeLabel.text = searchList[indexPath.row].type
        cell.posterImage.setImageFromUrl(ImageURL: searchList[indexPath.row].poster)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        page+=1
        if indexPath.row == searchList.count - 2, !isLoading {
                loadMoreData()
            }
    }
}

