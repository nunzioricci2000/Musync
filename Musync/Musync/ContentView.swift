//
//  ContentView.swift
//  Musync
//
//  Created by Nunzio Ricci on 13/07/23.
//

import SwiftUI
import RoleSelectionFeature
import ComposableArchitecture

struct ContentView: View {
    let store = Store(
        initialState: RoleSelectionFeature.State(),
        reducer: RoleSelectionFeature())
    
    var body: some View {
        VStack {}
            .sheet(isPresented: .constant(true)) {
                NavigationStack {
                    RoleSelectionView(store: store)
                }.interactiveDismissDisabled()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
