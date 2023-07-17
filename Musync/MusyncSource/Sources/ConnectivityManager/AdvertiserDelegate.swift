//
//  File.swift
//  
//
//  Created by Nunzio Ricci on 15/07/23.
//

import MultipeerConnectivity

extension ConnectivityManager: MCNearbyServiceAdvertiserDelegate {
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        updateHandler(
            .advertiser(
                Update.Invitation(
                    from: peerID,
                    withContext: context,
                    forSession: session,
                    invitationHandler: invitationHandler
                )
            )
        )
    }
}
