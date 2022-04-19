//
//  ViewModel.swift
//  Movies
//
//  Created by W.D. on 6/04/22.
//

import Foundation

enum ViewModelOutput {
    case updateMoviesArray(Data)
    case refreshTableView
    
}

class ViewModel {
    
    // MARK: - Internal Methods
    
    var outputEvents: Observable<ViewModelOutput> {
        mutableOutputEvents
    }
    
    // MARK: - Private Propertiers
    
    private let mutableOutputEvents = MutableObservable<ViewModelOutput>()
    
    // MARK: - Internal Methods
    
    func fetchMovies(textFieldText: String?, movieList: [Movie]) {
        guard let text = textFieldText, !text.isEmpty else {
            return
        }
        
        let query = text.replacingOccurrences(of: " ", with: "%20")
        
        URLSession.shared.dataTask(with: URL(string: "https://www.omdbapi.com/?apikey=3aea79ac&s=\(query)&tipe=movie")!,
        completionHandler: { data, response, error in
        guard let data = data, error == nil else {
            return
        }
        
        self.mutableOutputEvents.postValue(.updateMoviesArray(data))
        
        self.mutableOutputEvents.postValue(.refreshTableView)

        })
        .resume()
    }
    
}
