//
//  File.swift
//  
//
//  Created by Nunzio Ricci on 17/07/23.
//

import SwiftUI
import ComposableArchitecture

public struct RoleSelectionView: View {
    let store: StoreOf<RoleSelectionFeature>
    
    public init(store: StoreOf<RoleSelectionFeature>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }, send: { .view($0) }) { viewStore in
            List {
                Section("Join") {
                    Button(action: { viewStore.send(.join)}) {
                        Label("Join a room", systemImage: "person.badge.plus.fill")
                    }
                }
                if case let .loaded(playlists) = viewStore.playlists,
                   !playlists.isEmpty {
                    Section("Choose a playlist to open your room") {
                        ForEach(playlists) { playlist in
                            Button(playlist.name, action: { viewStore.send(.join) })
                        }
                    }
                } else if viewStore.playlists == .loading {
                    Section("Loading playlists...") {
                        ProgressView()
                    }
                }
            }
            .listStyle(.grouped)
            .navigationTitle("Choose role")
            .onAppear(perform: { viewStore.send(.onAppear)})
        }
    }
}

struct RoleSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RoleSelectionView(
                store: .init(
                    initialState: .init(),
                    reducer: RoleSelectionFeature.init
                )
            )
        }
    }
}
