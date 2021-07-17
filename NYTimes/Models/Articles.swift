//
//  Articles.swift
//  NYTimes
//
//  Created by Mannan on 15/07/2021.
//


import Foundation

// MARK: - Articles
struct Articles: Codable {
    let status, copyright: String?
    let numResults: Int?
    let results: [Article]?

    enum CodingKeys: String, CodingKey {
        case status, copyright
        case numResults = "num_results"
        case results
    }
}

// MARK: - Article
struct Article: Codable {
    let uri: String?
    let url: String?
    let id, assetID: Int?
    let source: Source?
    let publishedDate, updated, section, subsection: String?
    let nytdsection, adxKeywords: String?
    let byline: String?
    let type: ResultType?
    let title, abstract: String?
    let desFacet, orgFacet, perFacet, geoFacet: [String]?
    let media: [Media]?
    let etaID: Int?

    enum CodingKeys: String, CodingKey {
        case uri, url, id
        case assetID = "asset_id"
        case source
        case publishedDate = "published_date"
        case updated, section, subsection, nytdsection
        case adxKeywords = "adx_keywords"
        case byline, type, title, abstract
        case desFacet = "des_facet"
        case orgFacet = "org_facet"
        case perFacet = "per_facet"
        case geoFacet = "geo_facet"
        case media
        case etaID = "eta_id"
    }
}

// MARK: - Media
struct Media: Codable {
    let type: MediaType?
    let subtype: Subtype?
    let caption, copyright: String?
    let approvedForSyndication: Int?
    let mediaMetadata: [MediaMetadata]?

    enum CodingKeys: String, CodingKey {
        case type, subtype, caption, copyright
        case approvedForSyndication = "approved_for_syndication"
        case mediaMetadata = "media-metadata"
    }
}

// MARK: - MediaMetadatum
struct MediaMetadata: Codable {
    let url: String?
    let format: Format?
    let height, width: Int?
}

enum Format: String, Codable {
    case thumbnail = "Standard Thumbnail"
    case small = "mediumThreeByTwo210"
    case medium = "mediumThreeByTwo440"
}

enum Subtype: String, Codable {
    case empty = ""
    case photo = "photo"
}

enum MediaType: String, Codable {
    case image = "image"
}

enum Source: String, Codable {
    case newYorkTimes = "New York Times"
}

enum ResultType: String, Codable {
    case article = "Article"
    case interactive = "Interactive"
}