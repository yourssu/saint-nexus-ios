//
//  ActionItem.swift
//  
//
//  Created by Gyuni on 2022/05/01.
//

import Foundation

struct SNActionItem: Codable {
    let type: String
    let value: String?
    let ios: String?
    let requiredTemplates: [String]?
    
    init(type: String, value: String?, ios: String?, requiredTemplates: [String]?) {
        self.type = type
        self.value = value
        self.ios = ios
        self.requiredTemplates = requiredTemplates
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try container.decode(String.self, forKey: .type)
        ios = try? container.decode(String.self, forKey: .ios)
        requiredTemplates = try? container.decode([String]?.self, forKey: .requiredTemplates)
        
        do {
            value = try container.decode(String.self, forKey: .value)
        } catch DecodingError.typeMismatch {
            value = try String(container.decode(Int.self, forKey: .value))
        } catch is DecodingError {
            value = nil
        }
    }
}
