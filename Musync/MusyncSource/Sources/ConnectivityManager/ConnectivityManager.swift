//
//  ConnectivityManager.swift
//  
//
//  Created by Nunzio Ricci on 14/07/23.
//

import MultipeerConnectivity

// MARK: - ConnectivityManager

/// This object handles connectivity with other devices
public class ConnectivityManager: NSObject {
    let ownId: MCPeerID
    let session: MCSession
    var advertiser: MCNearbyServiceAdvertiser?
    var browser: MCNearbyServiceBrowser?
    
    private var handlers: [UUID: (Update) -> Void] = [:]
    
    /// This object handles connectivity with other devices
    ///
    /// - Parameters:
    ///  - name: this string will be provided as readable name to other devices
    ///  - updateHandler: handles updates from the connected devices
    public init(withName name: String) {
        ownId = .init(displayName: name)
        session = .init(peer: ownId,
                        securityIdentity: nil,
                        encryptionPreference: .optional)
        super.init()
        session.delegate = self
    }
    
    // TODO: - Better desctiption for service
    
    /// Starts advertising other devices that you are ready to recieve invitation
    ///
    /// - Parameter service: the string of the service
    public func startAdvertising(forService service: String) {
        stopAdvertising()
        advertiser = .init(peer: ownId, discoveryInfo: nil, serviceType: service)
        advertiser?.delegate = self
        advertiser?.startAdvertisingPeer()
    }
    
    /// Stop advertising other devices
    public func stopAdvertising() {
        advertiser?.stopAdvertisingPeer()
        advertiser = nil
    }
    
    /// Starts browsing devices that accept invitation
    ///
    /// - Parameter service: the string of the service
    public func startBrowsing(forService service: String) {
        browser = .init(peer: ownId, serviceType: service)
        browser?.delegate = self
        browser?.startBrowsingForPeers()
    }
    
    /// Sends a message encapsulated in a Data instance to nearby peers.
    ///
    /// - Parameters:
    ///   - data: An instance containing the message to send.
    ///   - peers: An array of peer ID instances representing the peers that should receive the message.
    ///   - mode: The transmission mode to use (reliable or unreliable delivery).
    public func send(_ data: Data, toPeers peers: [MCPeerID], with mode: MCSessionSendDataMode) throws {
        try session.send(data, toPeers: peers, with: mode)
    }
    
    /// Registers a new handler for updates
    ///
    /// - Parameter handler: handles future updates
    /// - Returns: a UUID that identifies the handler. Use it to remove the handler
    public func registerHandler(_ handler: @escaping (Update) -> ()) -> UUID {
        let id = UUID()
        handlers[id] = handler
        return id
    }
    
    /// Remove handler
    ///
    /// - Parameter id: the id of the handler retrived from the register method
    public func removeHandler(identifiedWith id: UUID) {
        handlers.removeValue(forKey: id)
    }
    
    func updateHandler(_ update: Update) -> Void {
        for handler in handlers.values {
            handler(update)
        }
    }

    deinit {
        advertiser?.stopAdvertisingPeer()
        browser?.stopBrowsingForPeers()
    }
}

extension ConnectivityManager {
    /// The list of currently connected peers
    public var connectedPeers: [MCPeerID] {
        session.connectedPeers
    }
}
