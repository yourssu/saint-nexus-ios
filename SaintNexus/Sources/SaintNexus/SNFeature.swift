//
//  SaintnexusFeature.swift
//  
//
//  Created by Gyuni on 2022/04/17.
//

import Foundation

public enum SNFeature {
    case personalInformation
    case chapel
    case latestReportCard
    case manuallyInput(String)
    
    public var actionURL: String {
        switch self {
        case .chapel:
            return "https://saint-nexus.yourssu.com/commands/getChapel-v1.json"
        case .personalInformation:
            return "https://saint-nexus.yourssu.com/commands/getInformation.json"
        case .latestReportCard:
            return "https://saint-nexus.yourssu.com/commands/getLatestReportCard-v1.json"
        case .manuallyInput(let url):
            return url
        }
    }
    
    public var type: Codable.Type {
        switch self {
        case .personalInformation:
            return SNResponse<SNPersonalInformation>.self
        case .latestReportCard:
            return SNResponse<SNSemesterReportCard>.self
        default:
            return Int.self
        }
    }
}
