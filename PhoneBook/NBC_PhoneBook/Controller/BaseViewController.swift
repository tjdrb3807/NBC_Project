//
//  BaseViewController.swift
//  NBC_PhoneBook
//
//  Created by 전성규 on 12/9/24.
//

import UIKit

class BaseViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindModel()
        self.configureNavigationBar()
        self.configureUI()
        self.setupConstraints()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false  // TODO: TIL 작성
        view.addGestureRecognizer(tapGesture)
    }
    
    func bindModel() {
        // Override Code..
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 20.0, weight: .bold)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        
        // Override Code..
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        // Override Code..
    }
    
    func setupConstraints() {
        // Override Code..
    }
    
    @objc private func dismissKeyboard() { view.endEditing(true) }
}

extension BaseViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        
        present(alert, animated: true)
    }
}
