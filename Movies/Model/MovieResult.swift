//
//  Movie.swift
//  Movies
//
//  Created by W.D. on 9/02/22.
//

import Foundation

struct MovieResult: Codable {
    let Search: [Movie]
    
}

struct Movie: Codable {
  let Title: String?
  let Year: String?
  let imdbID: String?
  let _Type: String?
  let Poster: String?
    
    private enum CodingKeys: String, CodingKey {
        case Title, Year, imdbID, _Type = "Type", Poster
    }
    
}
