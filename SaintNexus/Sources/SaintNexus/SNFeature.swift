//
//  SaintnexusFeature.swift
//  
//
//  Created by Gyuni on 2022/04/17.
//

import Foundation

public enum SNFeature {
    case validate
    case information
    case chapel
    case latestReportCard
    case singleReport
    case manuallyInput(String)
    
    public var actionURL: String {
        switch self {
        case .validate:
            return "https://saint-nexus.yourssu.com/commands/validate-v1.json"
        case .chapel:
            return "https://saint-nexus.yourssu.com/commands/getChapel-v1.json"
        case .information:
            return "https://saint-nexus.yourssu.com/commands/getInformation-v1.json"
        case .latestReportCard:
            return "https://saint-nexus.yourssu.com/commands/getLatestReportCard-v1.json"
        case .singleReport:
            return "https://saint-nexus.yourssu.com/commands/getSingleReport-v1.json"
        case .manuallyInput(let url):
            return url
        }
    }
}
