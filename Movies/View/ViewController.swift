//
//  ViewController.swift
//  Movies
//
//  Created by W.D. on 8/02/22.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    
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
    
    // MARK: - Private Properties
    
    private var adapter = MoviesAdapter()
 
    // MARK: - Lifecycle ViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(MyCollectionViewCell.nib(), forCellWithReuseIdentifier: MyCollectionViewCell.identifier)
        setCollectionViewDelegates(adapter, adapter)
        setTextFieldDelegate(adapter)
        setupBindigs()
    }
    
    // MARK: Internal Methods
    
    func setCollectionViewDelegates(_ delegate: UICollectionViewDelegate, _ datasource: UICollectionViewDataSource) {
        let _ = delegate
        let _ = datasource
    }
    
    func setTextFieldDelegate(_ delegate: UITextFieldDelegate) {
        let _ = delegate
    }
    
    // MARK: - Private Methods
    
    private func searchMovies() {
        textField.resignFirstResponder()
        viewmodel.fetchMovies(textFieldText: textField.text, movieList: movieList)
        movieList.removeAll()
    }
    
    private func setupBindigs() {
        viewmodel.outputEvents.observe { [weak self] event in
            self?.validateEvents(event: event)
        }
        adapter.didSelectSearch.observe { [weak self] in
            self?.searchMovies()
        }
        adapter.didSelectItemAt.observe { [weak self] movie in
            // TODO: - Pass the indexPath
            //self?.movieDetail(indexPath: )
        }
    }
    
    private func movieDetail(indexPath: IndexPath) {
        let url = "https://www.imdb.com/title/\(movieList[indexPath.row].imdbID ?? "")/"
        let vc = SFSafariViewController(url: URL(string: url)!)
        present(vc, animated: true)
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
