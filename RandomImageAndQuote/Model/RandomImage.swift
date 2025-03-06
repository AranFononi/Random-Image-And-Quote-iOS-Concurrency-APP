//
//  RandomImage.swift
//  RandomImageAndQuote
//
//  Created by Aaron Fononi on 26/02/2025.
//

import Foundation

struct RandomImage: Decodable {
    let id: Int
    let image: Data
    let quote: Quote
}

struct Quote: Decodable {
    let quote: String
    let author: String
    let category: String
}
