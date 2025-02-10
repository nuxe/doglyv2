////
////  SunoPlayerView.swift
////  DoglyV2
////
////  Created by Kush Agrawal on 2/9/25.
////
//
//import SwiftUI
//
//struct Song {
//    let imageURL: URL?
//    let title: String
//    let author: String
//    let authorImageURL: URL?
//    let caption: String
//    let subcaption: String
//    let actions: SunoActions
//}
//
//struct SunoActions {
//    let likes: Int
//    let dislikes: Int
//    let comments: Int
//}
//
//#Preview {
//    SunoPlayerView(song: Song(
//        imageURL: URL(string: "https://cdn2.suno.ai/image_large_35875c74-5aa2-4bec-a86f-d29a10dfacd5.jpeg"),
//        title: "Choti Si Umar, Badi Si Kahani",
//        author: "Kush",
//        authorImageURL: URL(string: "https://cdn1.suno.ai/defaultBlue.webp"),
//        caption: "Bollywood acoustic song about a child getting late for school. Bus is leaving in front of him",
//        subcaption: "[Verse] Ghanta baj gaya alarm ne dhoka diya",
//        actions: SunoActions(
//            likes: 0,
//            dislikes: 0,
//            comments: 0
//        )
//    ))
//}
//
//import SwiftUI
//
//struct SunoPlayerView: View {
//    
//    let song: Song
//    @State private var currentTime: TimeInterval = 0
//    @State private var totalTime: TimeInterval = 153 // 2:33 in seconds
//
//    var body: some View {
//        ZStack {
//            BackgroundImageView(imageURL: song.imageURL)
//
//            HStack(alignment: .bottom) {
//                VStack {
//                    // Top content
//                    SunoPlayerHeaderView(title: song.title, author: song.author, authorImageURL: song.authorImageURL)
//
//                    Spacer()
//
//                    // Bottom
//                    VStack(alignment: .leading) {
//                        SunoPlayerFooterView(caption: song.caption, subcaption: song.subcaption, currentTime: currentTime, totalTime: totalTime, actions: song.actions)
//                            .padding(.bottom, 16)
//                    }
//                }
//                
//                SunoActionsView(actions: song.actions)
//            }
//            .padding()
//        }
//    }
//}
//
//struct BackgroundImageView: View {
//    let imageURL: URL?
//    
//    var body: some View {
//        GeometryReader { geometry in
//            AsyncImage(url: imageURL) { image in
//                image
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .transition(.opacity)
//            } placeholder: {
//                Color.gray.opacity(0.5)
//            }
//            .overlay(content: {
//                Color.black.opacity(0.6)
//            })
//            .frame(width: geometry.size.width)
//        }
//        .ignoresSafeArea()
//    }
//}
//
//struct SunoPlayerHeaderView: View {
//    let title: String
//    let author: String
//    let authorImageURL: URL?
//    
//    var body: some View {
//        HStack {
//            AsyncImage(url: authorImageURL) { image in
//                image
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//            } placeholder: {
//                Circle()
//                    .fill(Color.gray)
//            }
//            .frame(width: 40, height: 40)
//            .clipShape(Circle())
//
//            VStack(alignment: .leading, spacing: 4) {
//                Text(title)
//                    .font(.headline)
//                Text(author)
//                    .font(.subheadline)
//            }
//            .foregroundColor(.white)
//        }
//    }
//}
//
//struct SunoPlayerFooterView: View {
//    let caption: String
//    let subcaption: String
//    let currentTime: TimeInterval
//    let totalTime: TimeInterval
//    let actions: SunoActions
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            Text(caption)
//                .font(.title3)
//                .bold()
//                .foregroundColor(.white)
//                .lineLimit(2)
//
//            Text(subcaption)
//                .font(.subheadline)
//                .foregroundColor(.gray)
//                .lineLimit(1)
//
//            PlaybackControlsView(currentTime: currentTime, totalTime: totalTime)
//        }
//    }
//}
//
//struct PlaybackControlsView: View {
//    let currentTime: TimeInterval
//    let totalTime: TimeInterval
//    
//    var body: some View {
//        VStack(spacing: 10) {
//            GeometryReader { geometry in
//                ZStack(alignment: .leading) {
//                    Rectangle()
//                        .fill(Color.white.opacity(0.3))
//                        .cornerRadius(2)
//                        .frame(height: 4)
//                    
//                    Rectangle()
//                        .fill(Color.white)
//                        .frame(width: geometry.size.width * CGFloat(currentTime / totalTime), height: 4)
//                        .cornerRadius(2)
//                }
//            }
//            .frame(height: 4)
//            
//            HStack {
//                Button(action: {}) {
//                    Image(systemName: "backward.fill")
//                }
//
//                Button(action: {}) {
//                    Image(systemName: "play.fill")
//                }
//
//                Spacer()
//                
//                Text(timeString(from: currentTime))
//                    .font(.caption)
//            }
//            .foregroundColor(.white)
//        }
//    }
//    
//    private func timeString(from timeInterval: TimeInterval) -> String {
//        let minutes = Int(timeInterval) / 60
//        let seconds = Int(timeInterval) % 60
//        return String(format: "%d:%02d", minutes, seconds)
//    }
//}
//
//struct SunoActionsView: View {
//    let actions: SunoActions
//    
//    var body: some View {
//        VStack {
//            InteractionButton(icon: "hand.thumbsup.fill", count: actions.likes)
//            InteractionButton(icon: "hand.thumbsdown.fill", count: actions.dislikes)
//            InteractionButton(icon: "message.fill", count: actions.comments)
//            InteractionButton(icon: "square.and.arrow.up", count: nil)
//            InteractionButton(icon: "ellipsis", count: nil)
//        }
//    }
//}
//
//struct InteractionButton: View {
//    let icon: String
//    let count: Int?
//    
//    var body: some View {
//        VStack(spacing: 4) {
//            Button(action: {}) {
//                Image(systemName: icon)
//                    .font(.title2)
//                    .foregroundColor(.white)
//                    .frame(width: 44, height: 44)
//                    .background(Color.black.opacity(0.4))
//                    .clipShape(Circle())
//            }
//            
//            if let count {
//                Text("\(count)")
//                    .font(.caption)
//                    .foregroundColor(.white)
//            }
//        }
//    }
//}
