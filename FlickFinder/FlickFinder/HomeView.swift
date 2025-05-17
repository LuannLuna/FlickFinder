import SwiftUI

struct HomeView: View {
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        VStack(spacing: 0) {
            // Top navigation
            HStack {
                Text("Home")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                Spacer()
                Circle()
                    .fill(Color.yellow)
                    .frame(width: 36, height: 36)
                    .overlay(
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black)
                    )
            }
            .padding()

            // Tab bar
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    LabelTab(title: "Popular", isSelected: true)
                    LabelTab(title: "New in")
                    LabelTab(title: "Action")
                    LabelTab(title: "Character")
                }
                .padding(.horizontal)
            }

            // Featured cards
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<5) { _ in
                        FeaturedCardView()
                    }
                }
                .padding()
            }

            // "Recommend to you"
            Text("Recommend to you")
                .font(.title3.bold())
                .foregroundColor(.white)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<5) { _ in
                        AsyncImage(url: URL(string: "https://via.placeholder.com/80")) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray.opacity(0.3)
                        }
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding()
            }

            Spacer()

            // Bottom Tab Bar
            CustomTabView(selectedTab: $selectedTab)
        }
        .background(
            Color.black
                .edgesIgnoringSafeArea(.all)
        )
    }
}

#Preview {
    HomeView()
}
