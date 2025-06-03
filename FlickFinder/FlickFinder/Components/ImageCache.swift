import SwiftUI

actor ImageCache {
    static let shared = ImageCache()
    
    private var cache: [URL: Image] = [:]
    private var loadingTasks: [URL: Task<Image?, Error>] = [:]
    
    private init() {}
    
    func image(for url: URL) async throws -> Image? {
        // Return cached image if available
        if let cachedImage = cache[url] {
            return cachedImage
        }
        
        // Return existing loading task if available
        if let existingTask = loadingTasks[url] {
            return try await existingTask.value
        }
        
        // Create new loading task
        let task = Task<Image?, Error> {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let uiImage = UIImage(data: data) else { return nil }
                let image = Image(uiImage: uiImage)
                cache[url] = image
                loadingTasks[url] = nil
                return image
            } catch {
                loadingTasks[url] = nil
                throw error
            }
        }
        
        loadingTasks[url] = task
        return try await task.value
    }
    
    func clearCache() {
        cache.removeAll()
        loadingTasks.values.forEach { $0.cancel() }
        loadingTasks.removeAll()
    }
} 