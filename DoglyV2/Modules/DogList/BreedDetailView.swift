//
//  BreedDetailView.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 2/9/25.
//

import SwiftUI

struct BreedDetailView: View {
    
//    @EnvironmentObject var viewModel: DogDetailViewModel
    @State var breedImageURL: URL?
    @State var counter: Int = 0

    var breed: Breed = .init(name: "Brad", isFavorite: true, subBreeds: [])

    var body: some View {
        ZStack {
            AsyncImage(url: breedImageURL) { image in
                image
                    .resizable()
                    .overlay {
                        Color.black.opacity(0.4)
                    }
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.vertical)
            } placeholder: {
                Color.gray
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
            VStack(alignment: .leading) {
                BreedDetailHeaderView()

                Spacer()

                HStack {
                    Text("\(counter)")
                        .font(.largeTitle)
                        .foregroundColor(.white)

                    BreedDetailActionsView(counter: $counter)
                }
            }
            .padding()

        }.onAppear {
//            Task {
//                let url = await viewModel.fetchBreedImage(breed.name)
//                if let image = url.first {
//                    breedImageURL = image
//                }
//            }
        }
    }
}

struct BreedDetailHeaderView: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Choti Si Umar, Badi si kahani")
            Text("Kush")
        }
        .foregroundColor(.white)
    }
}

struct BreedDetailActionsView: View {
    
    @Binding var counter: Int

    var symbols = ["pawprint.circle.fill", "pawprint.circle.fill", "pawprint.circle.fill", "pawprint.circle"]
    
    var body: some View {
        VStack {
            ForEach(symbols, id: \.self) { symbol in
                Button {
                    counter += 1
                } label: {
                    Image(systemName: symbol)
                      .font(.largeTitle)
                      .foregroundColor(.blue)
                    
                }.cornerRadius(30.0)
            }
        }
    }
    
}

#Preview {
    BreedDetailView(breedImageURL: URL(string: "https://images.dog.ceo/breeds/corgi-cardigan/n02113186_8846.jpg"))
}
