//
//  FetchDessertsTests.swift
//  FetchDessertsTests
//
//  Created by Riley Brookins on 1/29/24.
//

import XCTest
@testable import DessertFetch

final class FetchDessertsTests: XCTestCase {
    
    func test_dessert_ingredient() async {
        let expectation = XCTestExpectation(
          description: "Fetches meal details"
        )
        let mock = MockNetworkingManager()
        let dessertDetailVm = MealDetailsViewModel(dataFetching: mock)
        let asyncWaitDuration = 10.0
        
        await dessertDetailVm.getMealDetails(mealId: "test")

        DispatchQueue.main.asyncAfter(deadline: .now() + asyncWaitDuration) {
            expectation.fulfill()
                  
            XCTAssertEqual(dessertDetailVm.mealDetails[0].strMeal, "White chocolate creme brulee")
        }
        
        await fulfillment(of: [expectation], timeout: asyncWaitDuration)
    }
}
