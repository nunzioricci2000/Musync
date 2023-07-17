//
//  File.swift
//  
//
//  Created by Nunzio Ricci on 15/07/23.
//

import MultipeerConnectivity

extension ConnectivityManager: MCNearbyServiceBrowserDelegate {
    public func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        updateHandler(.browser(.found(peerID, withInfo: info)))
    }
    
    public func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        updateHandler(.browser(.lost(peerID)))
    }
}
