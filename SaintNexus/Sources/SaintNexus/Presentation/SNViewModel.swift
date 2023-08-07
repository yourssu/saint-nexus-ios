//
//  File.swift
//  
//
//  Created by 김윤서 on 2023/08/07.
//

import Foundation
import Combine

class SNViewModel: SNViewBindable {
    private let service = SNService()
    private let jsInterface = SNJSInterface()
    private var cancelBag = CancelBag()
    private let timeoutDuration: Int = 30

    let connectURL = PassthroughSubject<String, Never>()
    let evaluateJavaScript = PassthroughSubject<String, Never>()
    let errorOccured = PassthroughSubject<Error, Never>()
    let timeout = PassthroughSubject<Void, Never>()
    
    private var actionItems: [SNActionItem] = [SNActionItem]()
    private let currentActionItem = PassthroughSubject<SNActionItem, Never>()

    init() {
        currentActionItem
            .sink(receiveValue: { [weak self] currentActionItem in
                self?.doAction(currentActionItem)
            })
            .store(in: cancelBag)
    }
    private func doAction(_ action: SNActionItem) {
        Task {
            do {
                switch action.type {
                case "URL_CONNECT":
                    await self.actionWithURLConnect(about: action)
                case "JS_QUERY":
                    try await self.actionWithJSQuery(about: action)
                case "JS_MESSENGER":
                    try await self.actionWithJSMessanger(about: action)
                case "DELAY":
                    try await self.actionWithdelay(about: action)
                default:
                    return
                }

                doNextAction()
            } catch {
                errorOccured.send(error)
            }
        }
    }

    private func actionWithURLConnect(about work: SNActionItem) async {
        if let value = work.value {
            self.connectURL.send(value)
        }
    }

    private func actionWithJSQuery(about work: SNActionItem) async throws {
        if let url = work.value {
            let jsQuery = try await getJSQuery(from: url, requiredTemplates: work.requiredTemplates)
            self.evaluateJavaScript.send(jsQuery)
        }
    }

    private func actionWithJSMessanger(about work: SNActionItem) async throws {
        if let url = work.ios {
            let jsQuery = try await getJSQuery(from: url, requiredTemplates: work.requiredTemplates)
            self.evaluateJavaScript.send(jsQuery)
        }
    }

    private func actionWithdelay(about work: SNActionItem) async throws {
        if let value = work.value,
           let milliseconds = Int(value) {
            try await Task.sleep(nanoseconds: UInt64(milliseconds * 1_000_000))
        }
    }

    private func getJSQuery(from url: String, requiredTemplates: [String]?) async throws -> String {
        var jsQuery = try await service.getJSCode(from: url)

        if let requiredTemplates = requiredTemplates {
            jsQuery = jsInterface.replaceRequiredTemplates(jsCode: jsQuery, requiredTemplates: requiredTemplates)
        }

        return jsQuery
    }

    func loadActionItems(of feature: SNFeature) {
        Task {
            do {
                try actionItems = await service.getActionList(of: feature)
                doNextAction()
            } catch {
                errorOccured.send(error)
            }
        }
    }

    private func doNextAction() {
        if actionItems.isEmpty {
            timeout.send(())
        } else {
            currentActionItem.send(actionItems.removeFirst())
        }
    }

    deinit {
        print("SaintNexus ViewModel deinit")
    }
}


