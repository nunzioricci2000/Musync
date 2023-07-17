//
//  File.swift
//  
//
//  Created by Nunzio Ricci on 15/07/23.
//

import MultipeerConnectivity

extension ConnectivityManager: MCSessionDelegate {
    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        updateHandler(
            .session(.state(state, of: peerID))
        )
    }
    
    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        updateHandler(
            .session(.data(data, from: peerID))
        )
    }
    
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        updateHandler(
            .session(.stream(stream, named: streamName, from: peerID))
        )
    }
    
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        updateHandler(
            .session(.resource(named: resourceName, from: peerID, with: progress))
        )
    }
    
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        updateHandler(
            .session(.resourceCompleted(named: resourceName, from: peerID, at: localURL, with: error))
        )
    }
}
