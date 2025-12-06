//
//  ImageLoader.swift
//  BrainRush
//
//  Async image loading utility
//

import SwiftUI

struct AsyncImageView: View {
    let url: URL?
    let placeholder: String
    let contentMode: ContentMode
    
    @State private var image: UIImage?
    @State private var isLoading = false
    
    init(
        url: URL?,
        placeholder: String = "photo",
        contentMode: ContentMode = .fit
    ) {
        self.url = url
        self.placeholder = placeholder
        self.contentMode = contentMode
    }
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else {
                Image(systemName: placeholder)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .foregroundColor(.gray)
                    .overlay(
                        ProgressView()
                            .opacity(isLoading ? 1 : 0)
                    )
            }
        }
        .task {
            await loadImage()
        }
    }
    
    private func loadImage() async {
        guard let url = url else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                await MainActor.run {
                    self.image = uiImage
                }
            }
        } catch {
            // Handle error silently
        }
    }
}

#Preview {
    AsyncImageView(
        url: URL(string: "https://example.com/image.jpg"),
        placeholder: "person.circle"
    )
    .frame(width: 100, height: 100)
}
