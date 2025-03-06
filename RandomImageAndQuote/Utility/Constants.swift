//
//  Constants.swift
//  RandomImageAndQuote
//
//  Created by Aaron Fononi on 26/02/2025.
//

import Foundation

struct Constants {
    struct URLs {
        static func getRandomImageURL(id: Int) -> URL? {
            return URL(string: "https://picsum.photos/id/\(id)/2000/1000")
        }
        static let randomQuoteBaseURL: String = "https://api.api-ninjas.com/v1/quotes"
    }
    struct APIKeys {
        static let quotesAPIKey = "YOURAPIKEY"
    }
}
