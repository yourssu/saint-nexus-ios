//
//  SaintNexusViewController.swift
//  
//
//  Created by Gyuni on 2022/04/17.
//

import UIKit
import WebKit
import SwiftUI
import Combine

protocol SNViewBindable {
    //  Output
    var connectURL: PassthroughSubject<String, Never> { get }
    var evaluateJavaScript: PassthroughSubject<String, Never> { get }
    var errorOccured: PassthroughSubject<Error, Never> { get }
    var timeout: PassthroughSubject<Void, Never> { get }
    
    //  Input
    func loadActionItems(of feature: SNFeature)
}

class SNViewController: UIViewController, SNCoverUIViewAddable {
    
    var continuation: CheckedContinuation<String, Error>? = nil
    
    public var coverView: UIView?
    
    private let feature: SNFeature
    private let viewModel: SNViewBindable
    
    private var webView: WKWebView?
    private let webConfiguration = WKWebViewConfiguration()
    private let contentController = WKUserContentController()
    
    private var disposeBag = CancelBag()
    
    init(of feature: SNFeature,
         with viewModel: SNViewBindable) {
        self.feature = feature
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        bind()
        viewModel.loadActionItems(of: feature)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel.connectURL
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] urlString in
                if let url = URL(string: urlString) {
                    self?.webView?.load(URLRequest(url: url))
                }
            })
            .store(in: disposeBag)

        
        viewModel.evaluateJavaScript
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] jsCode in
                self?.webView?.evaluateJavaScript(jsCode)

            })
            .store(in: disposeBag)
        
        viewModel.errorOccured
            .sink(receiveValue: { [weak self] error in
                self?.continuation?.resume(throwing: error)
                self?.continuation = nil
            })
            .store(in: disposeBag)
        
        viewModel.timeout
            .sink(receiveValue: { [weak self] _ in
                self?.continuation?.resume(throwing: SNError.clientTimeout)
                self?.continuation = nil
            })
            .store(in: disposeBag)
    }
    
    override func loadView() {
        WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: Date(timeIntervalSince1970: 0), completionHandler: {})
        
        //  스크립트 핸들러 등록
        contentController.add(self, name: "scriptHandler")
        
        webConfiguration.userContentController = contentController
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView?.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let coverView = coverView else { return }

        view.addSubview(coverView)
        
        coverView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(coverView)
        view.bringSubviewToFront(coverView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: coverView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: coverView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: coverView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: coverView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0),
        ])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        contentController.removeScriptMessageHandler(forName: "scriptHandler")
        continuation?.resume(throwing: SNError.dismissed)
        continuation = nil
    }
    
    deinit {
        print("SaintNexus ViewController deinit")
    }
}

extension SNViewController: WKScriptMessageHandler {
    //  메시지 받으면 실행 됨
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        guard let bodyString = message.body as? String else { return }
        continuation?.resume(returning: bodyString)
        continuation = nil
    }
}

extension SNViewController: WKNavigationDelegate {
    //  에러 나면 실행 됨
    func webView(_ webView: WKWebView,
                 didFail navigation: WKNavigation!,
                 withError error: Error) {
        
        continuation?.resume(throwing: error)
        continuation = nil
    }
}
