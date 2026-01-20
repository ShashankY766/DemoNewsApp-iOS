//
//  NewsModels.swift
//  DemoNewsApp
//
//  Created by Shashank Yadav on 30/12/25.
//
import Foundation

// MARK: - Request Model
struct NewsRequest: Codable {
    let country: String
    let category: String
    let apiKey: String
}

// MARK: - Response Model
struct NewsResponse: Codable {
 //   let newsData: [Region]
    let status: String
    let totalResults: Int
    let articles: [Article]
}

//struct Region: Codable {
struct Article: Codable {
    //  let regionName: String
    //  let countries: [Country]
    let source: Source?
    let author: String?
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

struct Source: Codable {
 //   let countryName: String
 //   let newsList: [NewsItem]
    let id: String?
    let name: String

}
/*/
struct NewsItem: Codable {
    let title: String
    let briefDesc: String
    let news: String
}
*/
/*
 
 "source": {
     "id": null,
     "name": "Financial Times"
 },
 "author": "The editorial board",
 "title": "Three questions AI needs to answer - Financial Times",
 "description": "Evaluation of use cases and business models will dominate 2026",
 "url": "https://www.ft.com/content/a221f976-6b06-4916-9b87-96e63213d8a2",
 "urlToImage": "https://images.ft.com/v3/image/raw/https%3A%2F%2Fd1e00ek4ebabms.cloudfront.net%2Fproduction%2F6579a687-0c61-4eff-993b-724884f9d991.jpg?source=next-barrier-page",
 "publishedAt": "2026-01-02T11:00:05Z",
 "content": "Then $75 per month. Complete digital access to quality FT journalism on any device. Cancel anytime during your trial."
 */
