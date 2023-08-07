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
    public func getData(of feature: SNFeature) async throws -> String {
        let viewController = SNViewController(
            of: feature,
            with: SNViewModel()
        )
        
        delegate?.pushOrPresent(saintNexusViewController: viewController)
        
        defer {
            delegate?.dismissOrPop(saintNexusViewController: viewController)
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            viewController.continuation = continuation
        }
    }
    
    public func validateUser() async throws -> SNResponse<String> {
        let responseString = try await getData(of: .validate)
        return try SNResponse<String>(from: responseString)
    }
    
    public func loadChapel() async throws -> SNResponse<SNChapel> {
        let responseString = try await getData(of: .chapel)
        return try SNResponse<SNChapel>(from: responseString)
    }
    
    public func loadLatestReportCard() async throws -> SNResponse<SNSemesterReportCard> {
        let responseString = try await getData(of: .latestReportCard)
        return try SNResponse<SNSemesterReportCard>(from: responseString)
    }
    
    public func loadPersonalInformation() async throws -> SNResponse<SNPersonalInformation> {
        let responseString = try await getData(of: .information)
        return try SNResponse<SNPersonalInformation>(from: responseString)
    }
    
    public func loadManuallyInput(url: String) async throws -> String {
        return try await getData(of: .manuallyInput(url))
    }
}

public protocol SNDelegate: AnyObject {
    func pushOrPresent(saintNexusViewController viewController : UIViewController & SNCoverUIViewAddable)
    func dismissOrPop(saintNexusViewController viewController: UIViewController & SNCoverUIViewAddable)
}
