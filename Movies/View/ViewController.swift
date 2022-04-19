//
//  ViewController.swift
//  Movies
//
//  Created by W.D. on 8/02/22.
//

import UIKit
import SafariServices

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var textField: UITextField!

    // MARK: - Internal Properties
    var movieList = [Movie]()
    var viewmodel = ViewModel()
    
    var textFieldText: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
 
    // MARK: - Lifecycle ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(MyCollectionViewCell.nib(), forCellWithReuseIdentifier: MyCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        textField.delegate = self
        setupBindigs()
    }
    
    // MARK: Internal Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchMovies()
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell.identifier, for: indexPath) as! MyCollectionViewCell
        cell.configure(with: movieList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let url = "https://www.imdb.com/title/\(movieList[indexPath.row].imdbID ?? "")/"
        let vc = SFSafariViewController(url: URL(string: url)!)
        present(vc, animated: true)
    }
    
    func searchMovies() {
        textField.resignFirstResponder()
        
        viewmodel.fetchMovies(textFieldText: textField.text, movieList: movieList)
        
        movieList.removeAll()
        
    }
    
    // MARK: - Private Methods
    
    private func setupBindigs() {
        viewmodel.outputEvents.observe { [weak self] event in
            self?.validateEvents(event: event)
        }
    }
    
    private func validateEvents(event: ViewModelOutput) {
        switch event {
        case .updateMoviesArray(let data):
            // Convert
            var result: MovieResult?
            do {
                result = try JSONDecoder().decode(MovieResult.self, from: data)
            }
            catch {
                print("Error")
            }
            
            guard let finalResult = result else {
                return
            }
            
            // Update our movies array
            let newMovies = finalResult.Search
            self.movieList.append(contentsOf: newMovies)
        case .refreshTableView:
            // Refresh our table
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                }
        }
    }
}
