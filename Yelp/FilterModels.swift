//
//  FilterModels.swift
//  Yelp
//
//  Created by Varun on 9/23/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation

struct SortOption {
    init(_ displayName: String, _ value: YelpSortMode) {
        self.displayName = displayName
        self.value = value
    }
    var displayName: String
    var value: YelpSortMode
}

struct Distance {
    init(_ displayName: String, _ value: Int) {
        self.displayName = displayName
        self.value = value
    }
    var displayName: String
    var value: Int
}
