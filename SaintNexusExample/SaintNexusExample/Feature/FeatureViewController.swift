//
//  FeatureListView.swift
//  SaintNexusExample
//
//  Created by Gyuni on 2022/04/17.
//

import UIKit
import SaintNexus

import SwiftUI

struct FeatureListView: View {
    @ObservedObject var viewModel = FeatureViewModel()

    @State private var webViewController: UIViewController?
    @State private var isPresenting: Bool = false
    @State private var resultText: String = ""

    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.features, id: \.self) { feature in
                    Button(feature.name ?? "") {
                        Task {
                            do {
                                let response: Any

                                switch feature.action {
                                case .validate:
                                    response = try await SaintNexus.shared.validateUser()
                                case .chapel:
                                    response = try await SaintNexus.shared.loadChapel()
                                case .latestReportCard:
                                    response = try await SaintNexus.shared.loadLatestReportCard()
                                case .information:
                                    response = try await SaintNexus.shared.loadPersonalInformation()
                                case .manuallyInput(_):
                                    return
                                }

                                dump(response)
                                resultText = "success\n\(response)"
                                print(resultText)
                            } catch {
                                resultText = "error\n\(error)"
                                print(resultText)
                            }
                        }
                    }
                }
                Text(resultText)
            }
            .navigationBarTitle("Feature")
            .onReceive(SaintNexus.shared.pushOrPresent) { viewcontroller in
                webViewController = viewcontroller
                isPresenting = true
            }
            .onReceive(SaintNexus.shared.dismissOrPop) { _ in
                isPresenting = false
            }
            .sheet(isPresented: Binding<Bool>(
                get: { webViewController != nil && isPresenting },
                set: { isPresenting = $0 }
            ), onDismiss: {
                webViewController = nil
            }) {
                if let webViewController {
                    WebViewWrapper(viewController: webViewController)
                        .overlay {
                            Rectangle()
                                .fill(.cyan)
                                .ignoresSafeArea(.all)
                        }
                }
            }
        }
    }
}


struct WebViewWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController

    let viewController: UIViewController

    func makeUIViewController(context: Context) -> UIViewControllerType {
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // Update the view controller if needed
    }
}

final class FeatureHostingController: UIHostingController<FeatureListView> { }

