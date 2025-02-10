//
//  DogListView.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 2/9/25.
//

import SwiftUI

struct DogListView: View {
    
    @EnvironmentObject var viewModel: DogListViewModel
    
    var body: some View {
        NavigationSplitView {
            List(viewModel.breeds) { breed in
                NavigationLink {
                    BreedDetailView(breed: breed)
                } label: {
                    BreedRow(breed: breed)
                }
            }
            .navigationTitle("Breed")
        } detail: {
            Text("Select a Breed")
        }
        .onAppear {
            Task {
                await viewModel.fetchList()
            }
        }
    }
}

struct BreedRow: View {
    var breed: Breed

    var body: some View {
        HStack {
            Text(breed.name)

            Spacer()
            if breed.isFavorite {
                Image(systemName: "pawprint.circle.fill")
                  .font(.largeTitle)
                  .foregroundColor(.blue)
            } else {
                Image(systemName: "pawprint.circle")
                  .font(.largeTitle)
                  .foregroundColor(.blue)
            }
        }
    }
}


#Preview {
    DogListView()
}

