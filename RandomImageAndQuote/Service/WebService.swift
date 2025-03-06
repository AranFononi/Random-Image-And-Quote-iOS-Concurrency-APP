//
//  WebService.swift
//  RandomImageAndQuote
//
//  Created by Aaron Fononi on 26/02/2025.
//

import Foundation


enum WebServiceError: Error {
    case invalidImageURL
    case invalidQuoteURL
    case decodingFailed
}

class WebService {
    func getRandomImages(ids: [Int]) async throws -> [RandomImage] {
        var randomImages: [RandomImage] = []
        for id in ids {
            let randomImage = try await getRandomImage(id: id)
            randomImages.append(randomImage)
        }
        return randomImages
    }

     func getRandomImage(id: Int) async throws -> RandomImage {
        guard let imageUrl = Constants.URLs.getRandomImageURL(id: id) else {
            throw WebServiceError.invalidImageURL
        }
        
        async let (imageData, _) = try await URLSession.shared.data(from: imageUrl)
        async let quote = fetchRandomQuote()

        return RandomImage(id: id, image: try await imageData, quote: try await quote)
    }

    private func fetchRandomQuote() async throws -> Quote {
        guard let quoteURL = URL(string: Constants.URLs.randomQuoteBaseURL) else {
            throw WebServiceError.invalidQuoteURL
        }
        
        var request = URLRequest(url: quoteURL)
        request.setValue(Constants.APIKeys.quotesAPIKey, forHTTPHeaderField: "X-Api-Key")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        guard let quote = try? JSONDecoder().decode([Quote].self, from: data).first else {
            throw WebServiceError.decodingFailed
        }
        
        return quote
    }
}
