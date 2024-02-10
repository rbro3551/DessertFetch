//
//  FetchDessertsTests.swift
//  FetchDessertsTests
//
//  Created by Riley Brookins on 1/29/24.
//

import XCTest
@testable import DessertFetch

@MainActor
final class FetchDessertsTests: XCTestCase {
    
    func test_dessert_ingredient() async {

        let mock = MockNetworkingManager()
        let dessertDetailVm = MealDetailsViewModel(dataFetching: mock)

        
        await dessertDetailVm.getMealDetails(mealId: "test")


        XCTAssertEqual(dessertDetailVm.mealDetails[0].strMeal, "White chocolate creme brulee")
        
    }
}
