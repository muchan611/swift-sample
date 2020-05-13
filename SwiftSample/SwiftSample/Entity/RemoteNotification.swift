//
//  RemoteNotification.swift
//  SwiftSample
//
//  Created by Mutsumi Kakuta on 2020/05/13.
//  Copyright © 2020 Mutsumi Kakuta. All rights reserved.
//

import Foundation

struct RemoteNotification {
    struct PayloadDataEntity: Decodable {
        enum CodingKeys: String, CodingKey {
            case transitionType = "transition_type"
            case searchKeyword = "search_keyword"
            case order
            case productID = "product_id"
        }

        let transitionType: String
        let searchKeyword: String?
        let order: String?
        let productID: String?

        init(dictionary: [String: AnyObject]) throws {
            self = try JSONDecoder().decode(PayloadDataEntity.self, from: JSONSerialization.data(withJSONObject: dictionary))
        }
    }
    
    struct SearchResultsListEntity {
        let searchKeyword: String
        let order: String
    }
    
    struct ProductDetailEntity {
        let productID: String
    }

    enum TransitionType: String {
        case searchResultsList = "search_results_list"
        case productDetail = "product_detail"
    }

    enum NotificationType {
        case searchResultsList(SearchResultsListEntity)
        case productDetail(ProductDetailEntity)
    }

    enum NotificationError: Error {
        case invalidType
        case invalidData
    }

    static func convert(from data: [String: AnyObject]) throws -> NotificationType {
        let data = try PayloadDataEntity(dictionary: data)
        guard let transitionType = TransitionType(rawValue: data.transitionType) else { throw NotificationError.invalidType  }
        switch transitionType {
        case .searchResultsList:
            guard let searchKeyword = data.searchKeyword, let order = data.order else { throw NotificationError.invalidData }
            let entity = SearchResultsListEntity(searchKeyword: searchKeyword, order: order)
            return .searchResultsList(entity)
        case .productDetail:
            guard let productID = data.productID else { throw NotificationError.invalidData }
            let entity = ProductDetailEntity(productID: productID)
            return .productDetail(entity)
        }
    }
}
