//
//  FavouriteView.swift
//  DemoNewsApp
//
//  Created by Shashank Yadav on 21/01/26.
//
import SwiftUI
import Combine

struct FavouriteView: View {
    
    @EnvironmentObject private var favouritesStore: FavouritesStore
    // @Environment(\.favourites) var favourites: FavouritesStore
    // @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            List {
                ForEach(favouritesStore.favourites.indices, id: \.self) { index in
                    let article = favouritesStore.favourites[index]
                    
                    NavigationLink {
                        NewsDetailView(article: article)
                    } label: {
                        NewsRowView(article: article)
                    }
                }
            }
            
        }
        .navigationTitle("Favourite News")
        .navigationBarTitleDisplayMode(.inline)

        .toolbarBackground(Color.orange, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}





struct FavRowView: View {

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
