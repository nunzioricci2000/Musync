//
//  HostView.swift
//  Musync
//
//  Created by Nunzio Ricci on 14/07/23.
//

import SwiftUI
import MultipeerConnectivity

class HostViewModel: NSObject, ObservableObject {
    let serviceType = "musync"
    let ownId = MCPeerID(displayName: UIDevice.current.name)
    let peerBrowser: MCNearbyServiceBrowser
    let peerSession: MCSession
    
    @Published var message: String = ""
    @Published var foundPeers: [MCPeerID] = []
    @Published var connectedPeers: [MCPeerID] = []
    
    override init() {
        self.peerSession = MCSession(peer: ownId, securityIdentity: nil, encryptionPreference: .none)
        self.peerBrowser = MCNearbyServiceBrowser(peer: ownId, serviceType: serviceType)
        super.init()
        self.peerSession.delegate = self
        self.peerBrowser.delegate = self
        self.peerBrowser.startBrowsingForPeers()
    }
    
    func send(_ message: String, to peer: MCPeerID) {
        guard connectedPeers.contains(where: { $0 == peer }) else { return }
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(message)
            try peerSession.send(data, toPeers: [peer], with: .reliable)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func invite(_ peer: MCPeerID) {
        guard foundPeers.contains(where: { $0 == peer }) else { return }
        peerBrowser.invitePeer(peer, to: peerSession, withContext: nil, timeout: 10)
    }
}

extension HostViewModel: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .notConnected:
            DispatchQueue.main.async {
                self.connectedPeers.removeAll(where: { $0 == peerID })
            }
            print("\(peerID.displayName) disconnected!")
        case .connecting:
            print("\(peerID.displayName) connecting...")
        case .connected:
            DispatchQueue.main.async {
                self.connectedPeers.append(peerID)
            }
            print("\(peerID.displayName) connected!")
        @unknown default:
            print("Unknown case for MCSessionState")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let decoder = JSONDecoder()
        do {
            let message: String = try decoder.decode(String.self, from: data)
            DispatchQueue.main.async {
                self.message = message
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
}

extension HostViewModel: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        guard !self.foundPeers.contains(where: { $0 == peerID }) else { return }
        print("Found device named: \( peerID.displayName )")
        DispatchQueue.main.async {
            self.foundPeers.append(peerID)
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("\( peerID.displayName ): Connection lost!")
        DispatchQueue.main.async {
            self.foundPeers.removeAll { $0 == peerID }
        }
    }
}

struct HostView: View {
    @StateObject var viewModel: HostViewModel
    
    init(_ viewModel: HostViewModel) {
        self._viewModel = StateObject(wrappedValue: HostViewModel())
    }
    
    var body: some View {
        VStack {
            TextField("message", text: $viewModel.message)
            ForEach(viewModel.connectedPeers, id: \.self) { peer in
                Button("Send to \( peer.displayName )") {
                    viewModel.send(viewModel.message, to: peer)
                }
            }
            ForEach(viewModel.foundPeers, id: \.self) { peer in
                Button("Invite \( peer.displayName )") {
                    viewModel.invite(peer)
                }
            }
        }
    }
}

struct HostView_Previews: PreviewProvider {
    static var previews: some View {
        HostView(.init())
    }
}
