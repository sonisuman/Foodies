//
//  Place.swift
//  foodie
//
//  Created by Andi Setiyadi on 6/11/18.
//  Copyright © 2018 devhubs. All rights reserved.
//

import UIKit

struct Place: Codable {
    var placeInfo: PlaceInfo

    enum CodingKeys: String, CodingKey {
        case placeInfo = "restaurant"
    }
    
    struct PlaceInfo: Codable {
        var name: String
        var location: LocationInfo
        var imageURL: String
        var thumbImage: String
        var website: String
        
        enum CodingKeys: String, CodingKey {
            case name
            case location = "location"
            case imageURL = "featured_image"
            case thumbImage = "thumb"
            case website = "url"
        }
        
        struct LocationInfo: Codable {
            var address: String
        }
    }
}
