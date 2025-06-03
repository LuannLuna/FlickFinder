import SwiftUI

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    private let url: URL?
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder
    
    @State private var image: Image?
    @State private var isLoading = false
    @State private var error: Error?
    
    init(
        url: URL?,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let image = image {
                content(image)
            } else {
                placeholder()
            }
        }
        .task(id: url) {
            await loadImage()
        }
    }
    
    private func loadImage() async {
        guard let url = url else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            image = try await ImageCache.shared.image(for: url)
        } catch {
            self.error = error
            print("Failed to load image: \(error.localizedDescription)")
        }
    }
}

// MARK: - Convenience Initializers
extension CachedAsyncImage where Placeholder == ProgressView<EmptyView, EmptyView> {
    init(
        url: URL?,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (Image) -> Content
    ) {
        self.init(
            url: url,
            scale: scale,
            transaction: transaction,
            content: content,
            placeholder: { ProgressView() }
        )
    }
}

// MARK: - Preview
#if DEBUG
struct CachedAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        CachedAsyncImage(
            url: URL(string: "https://example.com/image.jpg")
        ) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}
#endif 