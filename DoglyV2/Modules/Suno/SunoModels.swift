//
//  SunoModels.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 2/9/25.
//

import Foundation
import SwiftUI

// MARK: - Network Models (minimal)
struct WorkspaceResponse: Codable {
    let projectClips: [ProjectClip]
    
    enum CodingKeys: String, CodingKey {
        case projectClips = "project_clips"
    }
}

struct ProjectClip: Codable {
    let clip: Clip
}

struct Clip: Codable, Identifiable {
    let id: String
    let imageLargeURL: URL
    let majorModelVersion: String
    let metadata: ClipMetadata
    let displayName: String
    let avatarImageURL: URL
    let reaction: Reaction
    let title: String
    let upvoteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageLargeURL = "image_large_url"
        case majorModelVersion = "major_model_version"
        case metadata
        case displayName = "display_name"
        case avatarImageURL = "avatar_image_url"
        case reaction
        case title
        case upvoteCount = "upvote_count"
    }
}

struct ClipMetadata: Codable {
    let prompt: String
    let gptDescriptionPrompt: String
    let duration: Double
    
    enum CodingKeys: String, CodingKey {
        case prompt
        case gptDescriptionPrompt = "gpt_description_prompt"
        case duration
    }
}

struct Reaction: Codable {
    let skipCount: Int
    let flagged: Bool
    
    enum CodingKeys: String, CodingKey {
        case skipCount = "skip_count"
        case flagged
    }
}

// MARK: - Preview Helpers
extension WorkspaceResponse {
    static var preview: WorkspaceResponse? {
        guard let url = Bundle.main.url(forResource: "workspace", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return nil
        }
        return try? JSONDecoder().decode(WorkspaceResponse.self, from: data)
    }
}
