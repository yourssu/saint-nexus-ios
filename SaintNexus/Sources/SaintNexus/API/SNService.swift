//
//  SNRepository.swift
//  
//
//  Created by Gyuni on 2022/05/01.
//

import Foundation

class SNService {
    private let repository = SNRepository()
    
    func getActionList(of feature: SNFeature) async throws -> [SNActionItem] {
        let data = try await repository.getActionItems(of: feature)
        
        do {
            return try JSONDecoder().decode([SNActionItem].self, from: data)
        } catch {
            let dataDescription = String(decoding: data, as: UTF8.self)
            throw SNError.failedToDecodeDataToActionItems(dataDescription: dataDescription)
        }
    }
    
    func getJSCode(from url: String) async throws -> String {
        let data = try await repository.getJSCode(from: url)
        return String(decoding: data, as: UTF8.self)
    }
    
    deinit {
        print("SaintNexus Repository deinit")
    }
}
