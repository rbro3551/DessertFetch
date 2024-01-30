//
//  Meal.swift
//  DessertFetch
//
//  Created by Riley Brookins on 1/29/24.
//

import Foundation


struct Meals: Codable {
    let meals: [Meal]
}

struct Meal: Codable, Comparable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
    
    static func <(lhs: Meal, rhs: Meal) -> Bool {
        lhs.strMeal < rhs.strMeal
    }
}
