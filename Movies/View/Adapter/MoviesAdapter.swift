//
//  MoviesAdapter.swift
//  Movies
//
//  Created by W.D. on 19/04/22.
//

import UIKit
import SafariServices

class MoviesAdapter: NSObject {
    
    // MARK: - Internal Properties
    
    var movieList = [Movie]()
    
    var didSelectItemAt: Observable<Movie> {
        mutableDidSelectItemAt
    }
    
    var didSelectSearch: Observable<Void> {
        mutableDidSelectSearch
    }
    
    // MARK: - Private Properties
    
    private var mutableDidSelectItemAt = MutableObservable<Movie>()
    private var mutableDidSelectSearch = MutableObservable<Void>()
    
}

// MARK: - UICollectionViewDataSource
extension MoviesAdapter: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell.identifier, for: indexPath) as! MyCollectionViewCell
        cell.configure(with: movieList[indexPath.row])
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension MoviesAdapter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        mutableDidSelectItemAt.postValue(movieList[indexPath.row])
    }
    
}

// MARK: - UICollectionViewDelegate
extension MoviesAdapter: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        mutableDidSelectSearch.postValue(())
        return true
    }
    
}
