//
//  SaintNexus.swift
//  
//
//  Created by Gyuni on 2022/04/17.
//

import UIKit

public class SaintNexus {
    public static let shared = SaintNexus()
    public weak var delegate: SNDelegate?
    public var userData: [String: String] = [String: String]()

    @MainActor
    public func getData(of feature: SNFeature) async throws -> Any {
        let viewController = SNViewController(of: feature,
                                              with: SNViewModel())
        
        delegate?.pushOrPresent(saintNexusViewController: viewController)
        
        defer {
            delegate?.dismissOrPop(saintNexusViewController: viewController)
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            viewController.continuation = continuation
        }
    }
    
    public func loadLatestReportCard() async throws -> SNResponse<SNSemesterReportCard> {
        return try await getData(of: .latestReportCard) as! SNResponse<SNSemesterReportCard>
    }
    
    public func loadChapel() async throws -> SNResponse<SNSemesterReportCard> {
        return try await getData(of: .latestReportCard) as! SNResponse<SNSemesterReportCard>
    }
    
    public func loadPersonalInformation() async throws -> SNResponse<SNPersonalInformation> {
        return try await getData(of: .personalInformation) as! SNResponse<SNPersonalInformation>
    }
    
    public func loadManuallyInput(url: String) async throws -> String {
        return try await getData(of: .manuallyInput(url)) as! String
    }
}

public protocol SNDelegate: AnyObject {
    func pushOrPresent(saintNexusViewController viewController : UIViewController & SNCoverViewAddable)
    func dismissOrPop(saintNexusViewController viewController: UIViewController & SNCoverViewAddable)
}
