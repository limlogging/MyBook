//
//  Book.swift
//  MyBook
//
//  Created by imhs on 5/5/24.
//

import Foundation

struct Book: Decodable {
    var documents: [Documents]
    var meta: Meta
}

struct Documents: Decodable {
    var authors: [String]
    var contents: String
    var datetime: String
    var isbn: String
    var price: Int
    var publisher: String
    var salePrice: Int
    var status: String
    var thumbnail: String
    var title: String
    var translators: [String]
    var url: String
    
    enum CodingKeys: String, CodingKey {
        case authors
        case contents
        case datetime
        case isbn
        case price
        case publisher
        case salePrice = "sale_price"
        case status
        case thumbnail
        case title
        case translators
        case url
    }
}

struct Meta: Decodable {
    var isEnd: Bool
    var pageableCount: Int
    var totalCount: Int
    
    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
}
