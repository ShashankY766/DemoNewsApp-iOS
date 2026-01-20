//
//  NewsDetailView.swift
//  DemoNewsApp
//
//  Created by Shashank Yadav on 17/01/26.
//

import SwiftUI

/// ------------------------------------------------------------
/// NewsDetailView (SwiftUI)
/// ------------------------------------------------------------
/// Direct SwiftUI replacement forController.swift
///
/// - UIViewController → View
/// - UIScrollView + UIStackView → ScrollView + VStack
/// - UILabel → Text
/// - UIImageView → Image
/// - UINavigationBarAppearance → toolbar + navigationTitle
/// - popViewController → dismiss()
///
/// ------------------------------------------------------------
struct NewsDetailView: View {

    // MARK: - Stored Properties (UIKit ivars equivalent)

    let article: Article
    @Environment(\.dismiss) private var dismiss

    @State private var image: UIImage? = nil
    @State private var showFavouriteAlert = false

    // MARK: - Body

    var body: some View {
        ScrollView {

            VStack(alignment: .leading, spacing: 8) {

                // Article Image (UIImageView equivalent)
                Group {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .foregroundColor(.secondary)
                    }
                }
                .scaledToFill()
                .frame(height: 220)
                .clipped()
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary, lineWidth: 3)
                )
                .background(Color(.secondarySystemBackground))

                // Headline
                Text(article.title)
                    .font(.title2)
                    .padding(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(Color.secondary, lineWidth: 0)
                    )

                /// Meta: Author + Date
                HStack(spacing: 4) {

                    Text(authorText)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)

                    Text(",")
                        .foregroundColor(.secondary)

                    Text(formattedDate(from: article.publishedAt))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)

                    Spacer()
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                      //  .stroke(Color.separator, lineWidth: 1)  Was not working
                        .stroke(Color(UIColor.separator), lineWidth: 0)
                )

                /// Description
                if let description = article.description {
                    Text(description)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                }

                /// Content
                if let content = article.content {
                    Text(content)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 24)
        }

        /// Navigation bar configuration (matches UIKit)
        .navigationTitle("News Details")
        .navigationBarTitleDisplayMode(.inline)

        /// Navigation bar right button (heart)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showFavouriteAlert = true
                } label: {
                    Image(systemName: "heart")
                        .foregroundColor(.black)
                }
            }
        }

        // Match UINavigationBarAppearance styling
        .toolbarBackground(Color.orange, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    //    .toolbarColorScheme(.dark, for: .navigationBar)    imparts yellowish visibilty to orange

        /// Favourite alert (same logic as UIKit)
        .alert("Add to Favourites", isPresented: $showFavouriteAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Coming Soon")
        }

        /// Load image when view appears
        .onAppear {
            loadImageIfNeeded()
        }
    }

    // MARK: - Helpers (UIKit private methods equivalent)

    /// Returns author or fallback
    private var authorText: String {
        if let author = article.author, !author.isEmpty {
            return author
        }
        return "Unknown Author"
    }

    /// Formats ISO date to dd/mm/yyyy
    private func formattedDate(from isoString: String?) -> String {
        guard let isoString = isoString else { return "" }
        let iso = ISO8601DateFormatter()
        if let date = iso.date(from: isoString) {
            let df = DateFormatter()
            df.dateFormat = "dd/mm/yyyy"
            return df.string(from: date)
        }
        return isoString
    }

    /// Loads article image asynchronously
    private func loadImageIfNeeded() {
        guard let urlString = article.urlToImage,
              let url = URL(string: urlString) else {
            return
        }

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
    NavigationStack {
        NewsDetailView(
            article: Article(
                source: nil,
                author: "John Doe",
                title: "Sample News Headline",
                description: "Sample description text",
                url: nil,
                urlToImage: nil,
                publishedAt: "2026-01-01T10:00:00Z",
                content: "Sample content body text"
            )
        )
    }
}

