//
//  File.swift
//  
//
//  Created by Nunzio Ricci on 17/07/23.
//

import ComposableArchitecture
import MusicKit
import LibraryClient

public struct RoleSelectionFeature: Reducer {
    public struct State: Equatable {
        var playlists: Playlists
        
        public init(playlists: Playlists = .notLoaded) {
            self.playlists = playlists
        }
        
        public enum Playlists: Equatable {
            case notLoaded
            case loading
            case loaded(MusicItemCollection<Playlist>)
            case error
        }
    }
    
    public enum Action {
        case fetchPlaylists
        case loadPlaylists(MusicItemCollection<Playlist>)
        case fetchError(Error)
        
        case view(View)
        public enum View {
            case join
            case open(Playlist)
            case onAppear
        }
    }
    
    @Dependency(\.libraryClient.fetchPlaylists) var fetchPlaylists
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchPlaylists:
                state.playlists = .loading
                return .run { send in
                    do {
                        let playlists = try await fetchPlaylists()
                        await send(.loadPlaylists(playlists))
                    } catch {
                        await send(.fetchError(error))
                        return
                    }
                }
                
            case let .loadPlaylists(playlists):
                state.playlists = .loaded(playlists)
                return .none
                
            case .fetchError:
                state.playlists = .error
                return .none
                
            case let .view(action):
                switch action {
                case .join:
                    return .none
                case .open:
                    return .none
                case .onAppear:
                    return .send(.fetchPlaylists)
                }
            }
        }
    }
    
    public init() {}
}
