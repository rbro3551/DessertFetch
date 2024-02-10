//
//  MealDetailsViewModel.swift
//  DessertFetch
//
//  Created by Riley Brookins on 1/29/24.
//

import Foundation

@MainActor
class MealDetailsViewModel: ObservableObject {
    private var mealsService: MealsService
    @Published var mealDetails: [MealDetails] = []
    
    init(dataFetching: DataFetching) {
        self.mealsService = MealsService(dataFetching: dataFetching)
    }
    
    
    func getMealDetails(mealId: String) async {
        // fetching the available details of the dessert by its id
        do {
            mealDetails = try await mealsService.getMealDetails(mealId: mealId)
        } catch {
            print("Error fetching data \(error)")
            mealDetails = []
        }
    }
}


class MealsService {
    private var networkManager: DataFetching
    
    init(dataFetching: DataFetching) {
        self.networkManager = dataFetching
    }
    
    func getMealDetails(mealId: String) async throws -> [MealDetails] {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(mealId)") else { return [] }
            let data = try await networkManager.download(url: url)
            let details = try JSONDecoder().decode(MealDetailsResponse.self, from: data)
            return details.meals
        }
    }
