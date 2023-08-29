//
//  File.swift
//  
//
//  Created by 김윤서 on 2023/08/16.
//

import SwiftUI
import Combine

class WebViewControllerHolder: ObservableObject {
    @Published var webViewController: UIViewController?
}

struct SaintNexusOnSheet<Cover: View>: ViewModifier {
    @ObservedObject var holder = WebViewControllerHolder()

    var coverView: () -> Cover

    func body(content: Content) -> some View {
        content
            .onReceive(SaintNexus.shared.pushOrPresent) { viewcontroller in
                holder.webViewController = viewcontroller
            }
            .onReceive(SaintNexus.shared.dismissOrPop) { _ in
                holder.webViewController = nil
            }
            .sheet(isPresented: Binding(
                get: { holder.webViewController != nil },
                set: { _ in }
            ), onDismiss: {
                holder.webViewController = nil
            }) {
                webViewContent()
            }
    }

    @ViewBuilder
    private func webViewContent() -> some View {
        if let viewController = holder.webViewController {
            WebViewWrapper(viewController: viewController)
                .overlay(content: coverView)
        } else {
            EmptyView()
        }
    }
}


struct SaintNexusOnPush<Cover: View>: ViewModifier {
    @ObservedObject var holder = WebViewControllerHolder()

    var coverView: () -> Cover

    func body(content: Content) -> some View {
        content
            .onReceive(SaintNexus.shared.pushOrPresent) { viewcontroller in
                holder.webViewController = viewcontroller
            }
            .onReceive(SaintNexus.shared.dismissOrPop) { _ in
                holder.webViewController = nil
            }
            .overlay {
                NavigationLink(
                    destination: webViewContent(),
                    isActive: Binding<Bool>(
                        get: { holder.webViewController != nil },
                        set: { _ in } )
                ) {
                    EmptyView()
                }
            }
    }

    @ViewBuilder
    private func webViewContent() -> some View {
        if let viewController = holder.webViewController {
            WebViewWrapper(viewController: viewController)
                .overlay(content: coverView)
                .onDisappear {
                    holder.webViewController = nil
                }
        } else {
            EmptyView()
        }
    }
}

extension View {
    public func saintNexusOnSheet<Cover: View>(
        coverView: @escaping () -> Cover
    ) -> some View {
        return modifier(SaintNexusOnSheet(coverView: {
            coverView()
        }))
    }

    public func saintNexusOnPush<Cover: View>(
        coverView: @escaping () -> Cover
    ) -> some View {
        return modifier(SaintNexusOnPush(coverView: {
            coverView()
        }))
    }
}


struct WebViewWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController

    let viewController: UIViewController

    func makeUIViewController(context: Context) -> UIViewControllerType {
        return viewController
    }

    func updateUIViewController(
        _ uiViewController: UIViewControllerType,
        context: Context
    ) { }
}
