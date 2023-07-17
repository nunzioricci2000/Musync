//
//  File.swift
//  
//
//  Created by Nunzio Ricci on 17/07/23.
//

import ComposableArchitecture
import MusicKit
import MusicManager

public struct LibraryClient {
    public var fetchPlaylists: () async throws -> MusicItemCollection<Playlist>
}

extension LibraryClient: DependencyKey {
    private static let musicManager = MusicManager()
    public static var liveValue: Self {
        .init(
            fetchPlaylists: { try await musicManager.fetch(from: "https://api.music.apple.com/v1/me/library/playlists") }
        )
    }
}

extension LibraryClient: TestDependencyKey {
    public static var previewValue: Self {
        .init(
            fetchPlaylists: {
                try await Task.sleep(for: .seconds(1))
                return []
            }
        )
    }
}

extension DependencyValues {
    public var libraryClient: LibraryClient {
        get { self[LibraryClient.self] }
        set { self[LibraryClient.self] = newValue }
    }
}
