//
//  ManuallyInputViewController.swift
//  SaintNexusExample
//
//  Created by Gyuni on 2022/06/05.
//

import Combine
import UIKit
import SaintNexus

class ManuallyInputViewController: UIViewController {

    private lazy var inputTextField = mapInputTextField()
    private lazy var button = mapButton()
    private lazy var resultTextView = mapResultTextView()
    private lazy var stackView = UIStackView()

    private var cancelBag = Set<AnyCancellable>()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        SaintNexus.shared.pushOrPresent
            .sink { [weak self] viewController in
                viewController.navigationItem.largeTitleDisplayMode = .never
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
            .store(in: &cancelBag)

        SaintNexus.shared.dismissOrPop
            .sink { viewController in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancelBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ManuallyInput"
        view.backgroundColor = .systemBackground
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 24, bottom: 20, right: 24)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(inputTextField)
        stackView.addArrangedSubview(button)
        stackView.addArrangedSubview(resultTextView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        button.addTarget(self, action: #selector(pushSNViewController), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }


    @objc func pushSNViewController() {
        Task {
            guard let url = inputTextField.text else { return }
            let resultText: String
            
            do {
                let response = try await SaintNexus.shared.loadManuallyInput(url: url)
                
                resultText = "success\n\(response)"
                resultTextView.text = resultText
            } catch {
                resultText = "error\n\(error)"
                resultTextView.text = resultText
            }
        }
    }
}
