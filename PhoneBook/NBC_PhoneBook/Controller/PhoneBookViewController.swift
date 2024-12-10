//
//  PhoneBookViewController.swift
//  NBC_PhoneBook
//
//  Created by 전성규 on 12/9/24.
//

import UIKit
import SnapKit

final class PhoneBookViewController: BaseViewController {
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 20.0
        
        return stackView
    }()
    
    private lazy var profileImageView = {
        let view = ProfileImageView()
        
        return view
    }()
    
    private let inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 5.0
        
        return stackView
    }()
    
    private let nameInputView = CustomTextInputView(type: .name)
    
    private let phoneNumberInputView = CustomTextInputView(type: .phoneNumber)
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        navigationItem.title = "연락처 추가"
    }
    
    override func configureUI() {
        super.configureUI()
        
        view.addSubview(contentStackView)
        
        [profileImageView, inputStackView].forEach { contentStackView.addArrangedSubview($0) }
        
        [nameInputView, phoneNumberInputView].forEach { inputStackView.addArrangedSubview($0) }
    }
    
    override func setupConstraints() {
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10.0)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20.0)
        }
        
        inputStackView.snp.makeConstraints { $0.width.equalToSuperview() }
        
        nameInputView.snp.makeConstraints { $0.height.equalTo(70.0) }
        
        phoneNumberInputView.snp.makeConstraints { $0.height.equalTo(70.0) }
    }
}

#if DEBUG

import SwiftUI

struct PhoneBookViewController_Previews: PreviewProvider {
    static var previews: some View {
        PhoneBookViewController_Presentable()
    }
    
    struct PhoneBookViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            UINavigationController(rootViewController: PhoneBookViewController())
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    }
}

#endif
