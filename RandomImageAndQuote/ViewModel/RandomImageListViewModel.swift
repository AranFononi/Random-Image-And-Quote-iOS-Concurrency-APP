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
    private let webService = WebService()
    
    
    func getRandomImage(ids: [Int]) async {
        
        var newRandomImages: [RandomImageViewModel] = []
        
        do {
            try await withThrowingTaskGroup(of: RandomImageViewModel?.self) { group in
                for id in ids {
                    group.addTask {
                        do {
                            let randomImage = try await self.webService.getRandomImage(id: id)
                            return RandomImageViewModel(randomImage: randomImage)
                        } catch {
                            print("Error fetching image for ID \(id): \(error)")
                            return nil
                        }
                    }
                }
                
                for try await result in group {
                    if let randomImageViewModel = result {
                        newRandomImages.append(randomImageViewModel)
                    }
                }
            }
            self.randomImages = newRandomImages
        } catch {
            print("Error in task group: \(error)")
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
