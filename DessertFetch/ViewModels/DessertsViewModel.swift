//
//  DessertsViewModel.swift
//  DessertFetch
//
//  Created by Riley Brookins on 1/29/24.
//

import Foundation
import Combine

@MainActor
class DessertsViewModel: ObservableObject {
    let mealListService: MealListService
    @Published var meals: [Meal] = []
    @Published var filteredMeals: [Meal] = []
    @Published var searchText = ""
    private var cancellables = Set<AnyCancellable>()
    
    init(dataFetching: DataFetching) {
        self.mealListService = MealListService(dataFetching: dataFetching)
    }
    
    
    func addSubscribers() {
        $searchText
            .combineLatest($meals)
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .map { (searchText, meals) -> [Meal] in
                // Sorting meals alphabetically based on the search text
                guard !searchText.isEmpty else {
                    return meals.sorted()
                }
                return meals.sorted().filter { $0.strMeal.localizedCaseInsensitiveContains(searchText) }
            }
            .sink { [weak self] (filterList) in
                self?.filteredMeals = filterList
            }
            .store(in: &cancellables)
    }
    
    // Fetch meal data using the network manager

    func getMeals() async {
        // Fetching initial list of desserts from provided url
        
        do {
            guard let mealsDict = try await mealListService.getMeals() else {
                meals = []
                return
            }
            meals = mealsDict.meals
        } catch {
            print("Error fetching data \(error)")
            meals = []
        }

        
    }
    
    func filteredMeals(meals: [Meal]) -> [Meal] {
        // Filtering dessert array alphabetically based on the searchText
        if !searchText.isEmpty {
            return meals.sorted().filter { $0.strMeal.localizedCaseInsensitiveContains(searchText) }
        } else {
            return meals.sorted()
        }
    }
}

class MealListService {
    private var networkManager: DataFetching
    
    init(dataFetching: DataFetching) {
        self.networkManager = dataFetching
    }
    
    func getMeals() async throws -> Meals? {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else { return nil }
            let data = try await networkManager.download(url: url)
            let meals = try JSONDecoder().decode(Meals.self, from: data)
            return meals
        }
    }
