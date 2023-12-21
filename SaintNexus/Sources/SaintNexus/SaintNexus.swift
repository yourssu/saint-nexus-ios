//
//  SaintNexus.swift
//  
//
//  Created by Gyuni on 2022/04/17.
//

import Combine
import UIKit
import SwiftUI

public class SaintNexus {
    public static let shared = SaintNexus()
    public var userData: [String: String] = [String: String]()

    public let pushOrPresent = PassthroughSubject<UIViewController & SNCoverUIViewAddable, Never>()
    public let dismissOrPop = PassthroughSubject<UIViewController & SNCoverUIViewAddable, Never>()

    @MainActor
    public func getData(of feature: SNFeature) async throws -> String {
        let viewController = SNViewController(
            of: feature,
            with: SNViewModel()
        )

        pushOrPresent.send(viewController)
        
        defer {
            dismissOrPop.send(viewController)
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

    public func loadSingleReport() async throws -> SNResponse<SNSemesterReportCard> {
        let responseString = try await getData(of: .singleReport)
        return try SNResponse<SNSemesterReportCard>(from: responseString)
    }

    public func loadManuallyInput(url: String) async throws -> String {
        return try await getData(of: .manuallyInput(url))
    }
}

public protocol SNPublisher {
    var webViewController: UIViewController? { get set }
    var pushOrPresentPublisher: AnyPublisher<UIViewController & SNCoverUIViewAddable, Never> { get  }
    var dismissOrPopPublisher: AnyPublisher<UIViewController & SNCoverUIViewAddable, Never> { get }
}

public extension SNPublisher {
    var pushOrPresentPublisher: AnyPublisher<UIViewController & SNCoverUIViewAddable, Never> {
        SaintNexus.shared.pushOrPresent.eraseToAnyPublisher()
    }
    var dismissOrPopPublisher: AnyPublisher<UIViewController & SNCoverUIViewAddable, Never> {
        SaintNexus.shared.dismissOrPop.eraseToAnyPublisher()
    }
}
