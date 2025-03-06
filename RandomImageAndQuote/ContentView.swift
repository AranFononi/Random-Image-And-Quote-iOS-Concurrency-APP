import SwiftUI

struct ContentView: View {
    
    @StateObject private var randomImageListVM = RandomImageListViewModel()
    
    var body: some View {
        NavigationStack {  // ✅ اضافه کردن NavigationStack
            List(randomImageListVM.randomImages) { randomImage in
                HStack {
                    randomImage.image.map {
                        Image(uiImage: $0)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                    }
                    Text(randomImage.quote)
                }
            }
            .task {
                do {
                    try await randomImageListVM
                        .getRandomImage(ids: Array(100...130))
                } catch {
                    print(error)
                }
            }
            .navigationTitle("Random Image/Quote")
            .toolbar {
                Button(action: {
                    Task {
                        try await randomImageListVM
                            .getRandomImage(ids: Array(100...130))
                    }
                }, label: {
                    Image(systemName: "arrow.clockwise.circle")
                })
            }
        }
    }
}

#Preview {
    ContentView()
}
