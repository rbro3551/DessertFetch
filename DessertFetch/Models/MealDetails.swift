//
//  MealDetails.swift
//  DessertFetch
//
//  Created by Riley Brookins on 1/29/24.
//

import Foundation


struct MealDetailsResponse: Decodable {
    let meals: [MealDetails]
}

struct MealDetails: Decodable {
    let idMeal: String
    let strMeal: String
    let strInstructions: String?
    let strMealThumb: String?
    let strYoutube: String?
    let ingredients: [Ingredient]
}

struct Ingredient: Codable, Identifiable {
    var id = UUID()
    let ingredient: String
    var measure: String
}

extension MealDetails {
    init(from decoder: Decoder) throws {
        // Custom decoding for ingredients
        let container = try decoder.singleValueContainer()
        let mealDict = try container.decode([String: String?].self)
        var index = 1
        var ingredients: [Ingredient] = []
        
        // Seperate the ingredients and their measures from the decoded data
        
        while let ingredient = mealDict["strIngredient\(index)"] as? String,
              let measure = mealDict["strMeasure\(index)"] as? String,
              !ingredient.isEmpty,
              !measure.isEmpty {
            
            // Handling duplicate ingredients by adding their measures
            
            var foundDuplicate = false
            
            for i in 0..<ingredients.count {
                if ingredients[i].ingredient == ingredient {

                    foundDuplicate = true
                    ingredients[i].measure += " + \(measure)"
                }
            }
            if !foundDuplicate {
                ingredients.append(Ingredient(ingredient: ingredient, measure: measure))
                index += 1
            } else {
                index += 1
            }
        }
            self.ingredients = ingredients
            // decoding the rest of the values
            idMeal = mealDict["idMeal"] as? String ?? ""
            strMeal = mealDict["strMeal"] as? String ?? ""
            strInstructions = mealDict["strInstructions"] as? String ?? ""
            strMealThumb = mealDict["strMealThumb"] as? String ?? ""
            strYoutube = mealDict["strYoutube"] as? String ?? ""
        }
    }
