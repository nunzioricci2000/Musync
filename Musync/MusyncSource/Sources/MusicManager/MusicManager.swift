//
//  MusicManager.swift
//  
//
//  Created by Nunzio Ricci on 17/07/23.
//

import Foundation
import MusicKit

public class MusicManager {
    
    private let decoder = JSONDecoder()
    
    public init() {
        
    }
    
    func checkAutorization() async -> MusicAuthorization.Status {
        let authorization: MusicAuthorization.Status = MusicAuthorization.currentStatus
        if authorization == MusicAuthorization.Status.notDetermined {
            return await MusicAuthorization.request()
        }
        return authorization
    }
    
    public func fetch<MusicType>(from url: String) async throws -> MusicType where MusicType: Decodable {
        let authorization = await checkAutorization()
        guard authorization == .authorized else { throw MusicError.invalidAuthorization(authorization) }
        guard let url = URL(string: url) else { throw MusicError.invalidUrl(url) }
        let request = MusicDataRequest(urlRequest: URLRequest(url: url))
        let response = try await request.response()
        return try decoder.decode(MusicType.self, from: response.data)
    }
}

enum MusicError: Error {
    case invalidAuthorization(MusicAuthorization.Status)
    case invalidUrl(String)
}
