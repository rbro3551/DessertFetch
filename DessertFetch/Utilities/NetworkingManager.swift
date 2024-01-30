//
//  NetworkingManager.swift
//  DessertFetch
//
//  Created by Riley Brookins on 1/29/24.
//

import Foundation

enum NetworkingError: LocalizedError {
    case badURLResponse(url: URL)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .badURLResponse(url: let url): return "[🔥] Bad response from URL. \(url)"
        case .unknown: return "[⚠️] Unknown error occured"
        }
    }
    

}

protocol DataFetching {
    func download(url: URL) async throws -> Data
}



class NetworkingManager: DataFetching {
    
    // Return data from url and handle the responsee
     func download(url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkingError.badURLResponse(url: url)
        }
        return data
    }
}
