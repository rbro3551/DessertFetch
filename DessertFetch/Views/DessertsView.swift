//
//  ContentView.swift
//  DessertFetch
//
//  Created by Riley Brookins on 1/29/24.
//

import SwiftUI

struct DessertsView: View {
    @StateObject var vm = DessertsViewModel(dataFetching: NetworkingManager())
    
    var body: some View {
        NavigationView {
            List(vm.filteredMeals, id: \.idMeal) { meal in
                NavigationLink {
                    MealDetailsView(id: meal.idMeal)
                        .navigationTitle("\(meal.strMeal)")
                } label: {
                    HStack {
                        AsyncImage(url: URL(string: meal.strMealThumb)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            } else {
                                ProgressView()
                                    .frame(width: 50, height: 50)
                            }
                        }
                        Text(meal.strMeal)
                    }
                    
                    
                }
            }
            .listStyle(.plain)
            .searchable(text: $vm.searchText, prompt: "Search for a dessert")
            .navigationTitle("DessertFetch")
        }
        .onAppear {
            Task {
                await vm.getMeals()
                vm.addSubscribers()
            }
        }
        
    }
}

#Preview {
    DessertsView()
}
