//
//  RandomImageListViewModel.swift
//  RandomImageAndQuote
//
//  Created by Aaron Fononi on 03/03/2025.
//

import Foundation
import SwiftUI

@MainActor
class RandomImageListViewModel: ObservableObject {
    
    @Published var randomImages: [RandomImageViewModel] = []
    
    
    func getRandomImage(ids: [Int]) async throws {
        
        let webService = WebService()
        randomImages = []
        
        do {
            try await withThrowingTaskGroup (of: (Int, RandomImage).self, body: { group in
                for id in ids {
                    group.addTask {
                        return (id, try await webService.getRandomImage(id: id))
                    }
                }
                for try await (_, randomImage) in group {
                    randomImages.append(RandomImageViewModel(randomImage: randomImage))
                }
            })
        } catch {
            print(error)
        }
    }
    
    struct RandomImageViewModel: Identifiable {
        let id = UUID()
        fileprivate let randomImage: RandomImage
        
        var image: UIImage? {
            UIImage(data: randomImage.image)
        }
        
        var quote: String {
            randomImage.quote.quote
        }
    }
}
