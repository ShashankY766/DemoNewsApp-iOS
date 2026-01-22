//
//  Favourite.swift
//  DemoNewsApp
//
//  Created by Shashank Yadav on 21/01/26.
//
//Foundation commented - Not needed
//import Foundation
import Combine


final class FavouritesStore: ObservableObject {

    /// Stored in insertion order
    @Published private(set) var favourites: [Article] = []

    /// Add only if not already present (by unique key, e.g. title + date)
    func add(_ article: Article) {
        guard !favourites.contains(where: { isSame($0, article) }) else {
            return
        }
        print("DEBUG Cache before adding: \(favourites)")
        favourites.append(article)
        print("DEBUG Cache after adding: \(favourites)")
    }

    func remove(_ article: Article) {
        favourites.removeAll { isSame($0, article) }
    }

    func isFavourite(_ article: Article) -> Bool {
        favourites.contains { isSame($0, article) }
    }

    private func isSame(_ a: Article, _ b: Article) -> Bool {
        // Define identity — adjust if you have an id field
        return a.title == b.title && a.publishedAt == b.publishedAt
    }
}
