//
//  GuestView.swift
//  Musync
//
//  Created by Nunzio Ricci on 14/07/23.
//

import SwiftUI
import MultipeerConnectivity

class GuestViewModel: NSObject, ObservableObject {
    let serviceType = "musync"
    let ownId = MCPeerID(displayName: UIDevice.current.name)
    let peerAdvertiser: MCNearbyServiceAdvertiser
    let peerSession: MCSession
    var connectedPeer: MCPeerID? = nil
    
    @Published var message = ""
    
    override init() {
        peerSession = MCSession(peer: ownId, securityIdentity: nil, encryptionPreference: .none)
        peerAdvertiser = MCNearbyServiceAdvertiser(peer: ownId, discoveryInfo: nil, serviceType: serviceType)
        super.init()
        peerSession.delegate = self
        peerAdvertiser.delegate = self
        peerAdvertiser.startAdvertisingPeer()
    }
    
    deinit {
        
    }
    
    func send(message: String) {
        guard let peer = connectedPeer else { return }
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(message)
            try peerSession.send(data,
                             toPeers: [peer],
                             with: .reliable)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension GuestViewModel: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        connectedPeer = session.connectedPeers.first
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

extension GuestViewModel: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("Invited by \( peerID.displayName )")
        invitationHandler(true, peerSession)
    }
}

struct GuestView: View {
    @StateObject var viewModel: GuestViewModel
    
    init(_ viewModel: GuestViewModel) {
        self._viewModel = StateObject(wrappedValue: GuestViewModel())
    }
    
    var body: some View {
        VStack {
            TextField("message", text: $viewModel.message)
            Button("Send") { viewModel.send(message: viewModel.message) }
        }
    }
}

struct GuestView_Previews: PreviewProvider {
    static var previews: some View {
        GuestView(.init())
    }
}
