//
//  BaseViewController.swift
//  Calculator01
//
//  Created by 전성규 on 11/19/24.
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
        self.configureUI()
        self.setupContraints()
    }
    
    func configureUI() {
        self.view.backgroundColor = .black
        // Override code..
    }
    
    func setupContraints() {
        // Override code..
    }
}
