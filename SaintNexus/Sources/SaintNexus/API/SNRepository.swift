//
//  SNRepository.swift
//  
//
//  Created by Gyuni on 2022/05/01.
//

import Foundation

class SNRepository {
    private let service = SNService()
    
    func getActionList(of feature: SNFeature) async throws -> [SNActionItem] {
        let data = try await service.getActionItems(of: feature)
        
        do {
            return try JSONDecoder().decode([SNActionItem].self, from: data)
        } catch {
            throw SNError.failedToDecodeDataToActionItems
        }
    }
    
    func getJSCode(from url: String) async throws -> String {
        let data = try await service.getJSCode(from: url)
        return String(decoding: data, as: UTF8.self)
    }
    
    deinit {
        print("SaintNexus Repository deinit")
    }
}
