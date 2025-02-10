//
//  SunoPlayerV3.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 2/10/25.
//

import SwiftUI

struct Song {
    let imageURL: URL?
    let title: String
    let author: String
    let authorImageURL: URL?
    let caption: String
    let subcaption: String
    let likes: Int
    let dislikes: Int
    let comments: Int
}

struct SunoPlayerViewV4: View {
    
    let song: Song
    @State private var counter: Int = 0

    var body: some View {
        ZStack {
            // Background Image
            
            // Content
        }.onAppear {
            Task {
                counter += 1
            }
        }
    }
    
    private var backgroundImage: some View {
        AsyncImage(url: , content: <#T##(Image) -> View#>, placeholder: <#T##() -> View#>)
    }
    
}

struct SunoPlayerView: View {
    let song: Song
    @State private var currentTime: TimeInterval = 0
    private let totalTime: TimeInterval = 153
    
    var body: some View {
        ZStack {
            // Background Image
            backgroundImage
            
            contentStack
        }
    }
    
    private var backgroundImage: some View {
        GeometryReader { geometry in
            AsyncImage(url: song.imageURL) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray
            }
            .frame(width: geometry.size.width)
            .overlay(Color.black.opacity(0.6))
            .ignoresSafeArea()
        }
    }
    
    private var contentStack: some View {
        HStack(alignment: .bottom) {
            VStack {
                header
                Spacer()
                footer
            }
            .foregroundColor(.white)
            actionsColumn
        }
        .padding()
    }
    
    private var header: some View {
        HStack {
            AsyncImage(url: song.authorImageURL) { image in
                image.resizable()
            } placeholder: {
                Circle().fill(Color.gray)
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(song.title).font(.headline)
                Text(song.author).font(.subheadline)
            }
        }
    }
    
    private var footer: some View {
        VStack(alignment: .leading) {
            Text(song.caption)
                .font(.title3)
                .bold()
            
            Text(song.subcaption)
                .font(.subheadline)
            
            // Playback Controls
            VStack(spacing: 10) {
                ProgressView(value: currentTime, total: totalTime)
                    .tint(.white)
                    .background(Color.white.opacity(0.3))
                
                HStack {
                    Button(action: {}) { Image(systemName: "backward.fill") }
                    Button(action: {}) { Image(systemName: "play.fill") }
                    Spacer()
                    Text("\(Int(currentTime)/60):\(Int(currentTime)%60, specifier: "%02d")")
                }
            }
        }
    }
    
    private var actionsColumn: some View {
        VStack {
            actionButton("hand.thumbsup.fill", count: song.likes)
            actionButton("hand.thumbsdown.fill", count: song.dislikes)
            actionButton("message.fill", count: song.comments)
            actionButton("square.and.arrow.up")
            actionButton("ellipsis")
        }
        .foregroundColor(.white)
    }
    
    private func actionButton(_ icon: String, count: Int? = nil) -> some View {
        VStack(spacing: 4) {
            Button {} label: {
                Image(systemName: icon)
                    .font(.title2)
                    .frame(width: 44, height: 44)
                    .background(Color.black.opacity(0.4))
                    .clipShape(Circle())
            }
            
            if let count {
                Text("\(count)").font(.caption)
            }
        }
    }
}

#Preview {
    SunoPlayerView(song: Song(
        imageURL: URL(string: "https://cdn2.suno.ai/image_large_35875c74-5aa2-4bec-a86f-d29a10dfacd5.jpeg"),
        title: "Choti Si Umar, Badi Si Kahani",
        author: "Kush",
        authorImageURL: URL(string: "https://cdn1.suno.ai/defaultBlue.webp"),
        caption: "Bollywood acoustic song about a child getting late for school. Bus is leaving in front of him",
        subcaption: "[Verse] Ghanta baj gaya alarm ne dhoka diya",
        likes: 10,
        dislikes: 2,
        comments: 5
    ))
}
