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
        
        self.configureNavigationBar()
        self.configureUI()
        self.setupConstraints()
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
}
