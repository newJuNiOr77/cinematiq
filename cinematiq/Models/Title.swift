//
//  Movie.swift
//  cinematiq
//
//  Created by Юрий on 30.07.2023.
//

import Foundation


struct TitleResponse: Codable {
    let results: [Title]
}

struct Title: Codable {
    let id: Int
    let media_type: String?
    let original_title: String?
    let original_name: String?
    let poster_path: String?
    let overview: String?
    let release_date:  String?
    let vote_count: Int
    let vote_average: Double
    let genre: [String]?

}
