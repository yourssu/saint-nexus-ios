//
//  ViewModel.swift
//  SaintNexusExample
//
//  Created by Gyuni on 2022/04/17.
//

import Foundation
import SaintNexus

class ViewModel {
    let features: [Feature] = [
        Feature(name: "getChapel", action: .chapel),
        Feature(name: "getInformation", action: .personalInformation),
        Feature(name: "getLatestReportCard", action: .latestReportCard),
    ]
}

struct Feature {
    let name: String?
    let action: SNFeature
}
