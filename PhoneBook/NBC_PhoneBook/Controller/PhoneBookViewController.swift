//
//  PhoneBookViewController.swift
//  NBC_PhoneBook
//
//  Created by 전성규 on 12/9/24.
//

import UIKit
import SnapKit

enum PhoneBookVCMode {
    case add
    case `default`
}

final class PhoneBookViewController: BaseViewController {
    var mode: PhoneBookVCMode!
    var model: ContactInfo!
    
    var modelDataChange: (() -> Void)?
    
    // MARK: Subviews
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
        if mode == .default {
            view.randomImageFetchButton.isHidden = true
            view.imageView.kf.setImage(with: model.profileImageURL)
            return view
        } else {
            view.delegate = self
        }
        
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
    
    private lazy var nameInputView = {
        let view = CustomTextInputView(type: .name)
        
        if mode == .default {
            view.textField.isEnabled = false
            view.textField.text = model.name
            return view
        } else {
            view.textField.delegate = self
            view.delegate = self
        }
        
        return view
    }()
    
    private lazy var phoneNumberInputView = {
        let view = CustomTextInputView(type: .phoneNumber)
        if mode == .default {
            view.textField.isEnabled = false
            view.textField.text = model.phoneNumber
            return view
        } else {
            view.textField.delegate = self
            view.delegate = self
        }
        
        return view
    }()
    
    // MARK: Override method.
    override func bindModel() {
        model.profileImageURLDidChange = { [weak self] in
            guard let self = self else { return }
            
            profileImageView.updateProfileImage(with: $0)
        }
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        
        guard let viewMode = mode else { return }
        
        switch viewMode {
        case .add:
            navigationItem.title = "연락처 추가"
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "적용",
                style: .done,
                target: self,
                action: #selector(rightBarButtonDidTap))
        case .default:
            navigationItem.title = "\(model.name)"
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        view.addSubview(contentStackView)
        
        [profileImageView, inputStackView].forEach { contentStackView.addArrangedSubview($0) }
        
        [nameInputView, phoneNumberInputView].forEach { inputStackView.addArrangedSubview($0) }
        
        if mode == .default,
           let nameInputView = inputStackView.arrangedSubviews.first as? CustomTextInputView {
            nameInputView.isHidden = true
        }
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
    
    // MARK: Event handling method.
    @objc private func rightBarButtonDidTap() {
        if nameInputView.textField.text!.isEmpty || phoneNumberInputView.textField.text!.isEmpty {
            showAlert(title: "알림", message: "필수사항을 입력해주세요.")
        } else {
            model.addData(model)
            modelDataChange?()
            navigationController?.popViewController(animated: true)
        }
    }
}

extension PhoneBookViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === nameInputView.textField {
            phoneNumberInputView.textField.becomeFirstResponder()
        } else if textField === phoneNumberInputView.textField {
            phoneNumberInputView.textField.resignFirstResponder()
        }
        
        return true
    }
}

extension PhoneBookViewController: ProfileImageViewDelegate {
    func updateProfileImage() {
        model.fetchRandomProfileImageURL(with: "https://pokeapi.co/api/v2/pokemon/")
    }
}

extension PhoneBookViewController: CustomTextInputViewDelegate {
    func updateTextData(_ textField: UITextField, value: String) {
        if textField == nameInputView.textField {
            model.updateName(value)
        } else if textField == phoneNumberInputView.textField {
            model.updatePhoneNumber(value)
        }
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
            let vc = PhoneBookViewController()
            vc.mode = .add
            
            return UINavigationController(rootViewController: vc)
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    }
}

#endif
