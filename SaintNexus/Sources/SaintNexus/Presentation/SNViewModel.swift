//
//  SNViewModel.swift
//  
//
//  Created by Gyuni on 2022/04/17.
//

import RxCocoa
import RxSwift
import Foundation

class SNViewModel: SNViewBindable {
    private let service = SNService()
    private let jsInterface = SNJSInterface()
    private var disposeBag = DisposeBag()
    
    private let timeoutDuration: Int = 10
    
    //  Output
    var connectURL: Signal<String>
    var evaluateJavaScript: Signal<String>
    var errorOccured: Signal<Error>
    var timeout: Signal<Void>
    
    private let _connectURL: PublishRelay<String> = PublishRelay<String>()
    private let _evaluateJavaScript: PublishRelay<String> = PublishRelay<String>()
    private let _errorOccured: PublishRelay<Error> = PublishRelay<Error>()
    private let _timeout: PublishRelay<Void> = PublishRelay<Void>()
    
    private var actionItems: [SNActionItem] = [SNActionItem]()
    private let currentActionItem: PublishRelay<SNActionItem> = PublishRelay<SNActionItem>()
    
    init() {
        connectURL = _connectURL.asSignal(onErrorSignalWith: .empty())
        evaluateJavaScript = _evaluateJavaScript.asSignal(onErrorSignalWith: .empty())
        errorOccured = _errorOccured.asSignal(onErrorSignalWith: .empty())
        
        timeout = _timeout
            .take(1)
            .delay(.seconds(timeoutDuration), scheduler: MainScheduler.instance)
            .asSignal(onErrorSignalWith: .empty())
        
        currentActionItem
            .subscribe(onNext: { [weak self] action in
                self?.doAction(action)
            })
            .disposed(by: disposeBag)
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
                _errorOccured.accept(error)
            }
        }
    }
    
    private func actionWithURLConnect(about work: SNActionItem) async {
        if let value = work.value {
            self._connectURL.accept(value)
        }
    }
    
    private func actionWithJSQuery(about work: SNActionItem) async throws {
        if let url = work.value {
            let jsQuery = try await getJSQuery(from: url, requiredTemplates: work.requiredTemplates)
            self._evaluateJavaScript.accept(jsQuery)
        }
    }
    
    private func actionWithJSMessanger(about work: SNActionItem) async throws {
        if let url = work.ios {
            let jsQuery = try await getJSQuery(from: url, requiredTemplates: work.requiredTemplates)
            self._evaluateJavaScript.accept(jsQuery)
        }
    }
    
    
    private func actionWithdelay(about work: SNActionItem) async throws {
        if let value = work.value,
           let milliseconds = Int(value) {
            try await Task.sleep(nanoseconds: UInt64(milliseconds * 5 * 1_000_000))
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
                _errorOccured.accept(error)
            }
        }
    }
    
    private func doNextAction() {
        if actionItems.isEmpty {
            _timeout.accept(())
        } else {
            currentActionItem.accept(actionItems.removeFirst())
        }
    }
    
    deinit {
        print("SaintNexus ViewModel deinit")
    }
}


