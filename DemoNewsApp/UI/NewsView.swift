//
//  NewsView.swift
//  DemoNewsApp
//

import SwiftUI

struct NewsView: View {

    // State

    @State private var articles: [Article] = []
    @State private var showFavouriteAlert: Bool = false
    @State private var selectedArticleIndex: Int = -1
    @State private var navigateToDetail: Bool = false
    @State private var navigateToFavourite: Bool = false
    
    @EnvironmentObject private var favouritesStore: FavouritesStore

    // Body

    var body: some View {

        ScrollView {
            LazyVStack(spacing: 12) {

                ForEach(articles.indices, id: \.self) { index in
                    let item = articles[index]

                    Button {
                        selectedArticleIndex = index
                        navigateToDetail = true
                    } label: {
                        NewsRowView(article: item)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 12)
        }

        .navigationTitle("News")
        .navigationBarTitleDisplayMode(.inline)

        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    //showFavouriteAlert = true
                    navigateToFavourite = true
                } label: {
                    Image(systemName: "heart")
                        .foregroundColor(.white)
                }
            }
        }
        
        .navigationDestination(isPresented: $navigateToFavourite) {
            FavouriteView()
        }

        .toolbarBackground(Color.orange, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
      //  .toolbarColorScheme(.light, for: .navigationBar)

        .navigationDestination(isPresented: $navigateToDetail) {
            if selectedArticleIndex >= 0,
               selectedArticleIndex < articles.count {

                NewsDetailView(article: articles[selectedArticleIndex])
            }
        }

        //Show Favourites via Object Cache is implemented
 /*       .alert("Show Favourites", isPresented: $showFavouriteAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Coming Soon")
        }*/

        .onAppear {
            navigateToFavourite = false
            fetchNews()
        }
    }

    // API (MUST be inside struct)

    private func fetchNews() {

        let request = NewsRequest(
            country: "us",
            category: "business",
            apiKey: "3bb87c4d144b4f1a87fccf0bb71062aa"
        )

        NetworkManager.newsAPI(request: request) { (result: Result<[Article], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let articles):
                    self.articles = articles   // ✅ self now valid
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}

// Row View

struct NewsRowView: View {

    let article: Article
    @State private var image: UIImage? = nil

    var body: some View {
        HStack(spacing: 8) {

            Group {
                if let image = image {
                    Image(uiImage: image).resizable()
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 100, height: 85)
            .scaledToFill()
            .clipped()

            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(.subheadline)
                    .lineLimit(1)

                Text(article.description ?? "")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }

            Spacer()
        }
        .padding(10)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
        .onAppear {
            loadImageIfNeeded()
        }
    }

    private func loadImageIfNeeded() {
        guard let urlString = article.urlToImage,
              let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let img = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = img
                }
            }
        }.resume()
    }
}

#Preview {
    NewsView()
}
