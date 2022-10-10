//
//  FeatureViewController.swift
//  SaintNexusExample
//
//  Created by Gyuni on 2022/04/17.
//

import UIKit
import SaintNexus

class FeatureViewController: UITableViewController {
    private let viewModel = FeatureViewModel()
    private lazy var footerView: UITextView = mapFooterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Feature"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = footerView
        footerView.frame = CGRect(
            x: 0,
            y: tableView.safeAreaInsets.top,
            width: view.frame.width,
            height: 500
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        SaintNexus.shared.delegate = self
    }
}

extension FeatureViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = viewModel.features[indexPath.row].name
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.features.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Task {
            let resultText: String
            
            do {
                let response: Any
                
                switch viewModel.features[indexPath.row].action {
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
                
                resultText = "success\n\(response)"
                footerView.text = resultText
                print(resultText)
            } catch {
                resultText = "error\n\(error)"
                footerView.text = resultText
                print(resultText)
            }
        }   
    }
}

extension FeatureViewController: SNDelegate {
    func pushOrPresent(saintNexusViewController viewController: UIViewController & SNCoverViewAddable) {
        viewController.navigationItem.largeTitleDisplayMode = .never
        
//        let coverView = mapCoverView()
//        viewController.coverView = coverView
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func dismissOrPop(saintNexusViewController viewController: UIViewController & SNCoverViewAddable) {
        viewController.navigationController?.popViewController(animated: true)
    }
}

