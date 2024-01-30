//
//  MealDetailsViewModel.swift
//  DessertFetch
//
//  Created by Riley Brookins on 1/29/24.
//

import Foundation

class MealDetailsViewModel: ObservableObject {
    private var networkManager: DataFetching
    @Published var mealDetails: [MealDetails] = []
    
    init(dataFetching: DataFetching) {
        self.networkManager = dataFetching
    }
    
    
    func getMealDetails(mealId: String) async {
        // fetching the available details of the dessert by its id
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(mealId)") else { return }
        Task { @MainActor in
            do {
                let data = try await networkManager.download(url: url)
                let mealDetailsResponse = try JSONDecoder().decode(MealDetailsResponse.self, from: data)
                mealDetails = mealDetailsResponse.meals
            } catch {
                print("Error fetching data \(error)")
                mealDetails = []
            }
        }
        
    }
}
