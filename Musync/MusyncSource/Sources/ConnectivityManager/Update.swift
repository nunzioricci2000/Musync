//
//  File.swift
//  
//
//  Created by Nunzio Ricci on 14/07/23.
//

import MultipeerConnectivity

extension ConnectivityManager {
    /// This enum describes the type of update
    /// arrived from MultipeerConnectivity framework
    public enum Update {
        /// Browser update
        case browser(Browser)
        
        /// Advertising update
        case advertiser(Invitation)
        
        /// Session update
        case session(Session)
        
        /// Describes session updates
        public enum Session {
            
            /// the state of a peer changed
            case state(MCSessionState, of: MCPeerID)
            
            /// a peer sent you data
            case data(Data, from: MCPeerID)
            
            /// a peer started streaming data to you
            case stream(InputStream, named: String, from: MCPeerID)
            
            /// update on progress of resource transfer
            case resource(named: String, from: MCPeerID, with: Progress)
            
            /// resource transfer completes
            case resourceCompleted(named: String, from: MCPeerID, at: URL?, with: Error?)
        }
        
        /// Describes invitations from other peers
        public struct Invitation {
            /// id of the sender
            public let peerId: MCPeerID
            
            /// additional payload
            public let context: Data?
            
            /// accept (or dismiss) invitation
            /// - Parameter accepted: If true accept invitation, else dismiss it
            func accept(_ accepted: Bool = true) {
                _invitationHandler(accepted, session)
            }
            
            private let session: MCSession
            private let _invitationHandler: (Bool, MCSession?) -> Void
            
            init(from peer: MCPeerID,
                 withContext context: Data?,
                 forSession session: MCSession,
                 invitationHandler: @escaping (Bool, MCSession?) -> Void) {
                self.peerId = peer
                self.context = context
                self.session = session
                self._invitationHandler = invitationHandler
            }
            
        }
        
        /// Describes discoveries done by the browser
        public enum Browser {
            
            /// new peer found
            case found(MCPeerID, withInfo: [String: String]?)
            
            /// lost connection with a peer
            case lost(MCPeerID)
        }
    }
}
