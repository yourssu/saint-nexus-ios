//
//  SNRepository.swift
//  
//
//  Created by Gyuni on 2022/05/01.
//

import Foundation

class SNRepository {
    func getActionItems(of feature: SNFeature) async throws -> Data {
        guard let url = URL(string: feature.actionURL) else { throw SNError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
            throw SNError.failedToLoadDataFromServer
        }
        
        return data
    }
    
    func getJSCode(from url: String) async throws -> Data {
        print(url)
        let url = url.replacingOccurrences(of: "http://", with: "https://")
        guard let url = URL(string: url) else { throw SNError.invalidURL }
        
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
