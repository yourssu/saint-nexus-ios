//
//  SNRepository.swift
//  
//
//  Created by Gyuni on 2022/05/01.
//

import Foundation

class SNRepository {
    func getActionItems(of feature: SNFeature) async throws -> Data {
        let timestamp = Int64(Date().timeIntervalSince1970 * 1000)
        guard let url = URL(string: "\(feature.actionURL)?t=\(timestamp)") else { throw SNError.invalidURL(url: "\(feature.actionURL)?t=\(timestamp)") }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
            throw SNError.failedToLoadDataFromServer
        }
        
        return data
    }
    
    func getJSCode(from url: String) async throws -> Data {
        let url = url.replacingOccurrences(of: "http://", with: "https://")
        let timestamp = Int64(Date().timeIntervalSince1970 * 1000)
        guard let url = URL(string: "\(url)?t=\(timestamp)") else { throw SNError.invalidURL(url: "\(url)?t=\(timestamp)") }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
            throw SNError.failedToLoadDataFromServer
        }
        
        return data
    }
    
    deinit {
        print("SaintNexus Repository deinit")
    }
}
