//
//  IngredientView.swift
//  DessertFetch
//
//  Created by Riley Brookins on 1/29/24.
//

import SwiftUI

struct IngredientView: View {
    let ingredients: [Ingredient]
    
    var body: some View {
        List(ingredients, id: \.id) { ingredient in
            // Checking for blank values
            if ingredient.ingredient != "" {
                Text("\(ingredient.ingredient): \(ingredient.measure) ")
            }
        }
    }
}

#Preview {
    IngredientView(ingredients: [])
}
