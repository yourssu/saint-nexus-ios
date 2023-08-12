//
//  FeatureViewModel.swift
//  SaintNexusExample
//
//  Created by Gyuni on 2022/04/17.
//

import Foundation
import SaintNexus

class FeatureViewModel: ObservableObject {
    let features: [Feature] = [
        Feature(name: "validate", action: .validate),
        Feature(name: "getChapel", action: .chapel),
        Feature(name: "getInformation", action: .information),
        Feature(name: "getLatestReportCard", action: .latestReportCard),
    ]
}

struct Feature {
    let uuid: UUID = UUID()
    let name: String?
    let action: SNFeature
}

extension Feature: Hashable, Equatable {
    static func == (lhs: Feature, rhs: Feature) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

