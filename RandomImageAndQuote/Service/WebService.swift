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
        return try await withThrowingTaskGroup(of: RandomImage.self) { group in
            for id in ids {
                group.addTask {
                    return try await self.getRandomImage(id: id)
                }
            }
                
            var randomImages: [RandomImage] = []
            for try await image in group {
                randomImages.append(image)
            }
            return randomImages
        }
    }

    func getRandomImage(id: Int) async throws -> RandomImage {
        guard let imageUrl = Constants.URLs.getRandomImageURL(id: id) else {
            throw WebServiceError.invalidImageURL
        }
            
        async let (imageData, _) = URLSession.shared.data(from: imageUrl)
        async let quote = fetchRandomQuote()

        return RandomImage(
            id: id,
            image: try await imageData,
            quote: try await quote
        )
    }

    private func fetchRandomQuote() async throws -> Quote {
        guard let quoteURL = URL(string: Constants.URLs.randomQuoteBaseURL) else {
            throw WebServiceError.invalidQuoteURL
        }
            
        var request = URLRequest(url: quoteURL)
        request
            .setValue(
                Constants.APIKeys.quotesAPIKey,
                forHTTPHeaderField: "X-Api-Key"
            )
            
        let (data, _) = try await URLSession.shared.data(for: request)
            
        do {
            let quotes = try JSONDecoder().decode([Quote].self, from: data)
            if let quote = quotes.first {
                return quote
            } else {
                throw WebServiceError.decodingFailed
            }
        } catch {
            throw WebServiceError.decodingFailed
        }
    }
}
