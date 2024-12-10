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
    var mode: PhoneBookVCMode?
    
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
            return view
        } else {
            view.textField.delegate = self
        }
        
        return view
    }()
    
    private lazy var phoneNumberInputView = {
        let view = CustomTextInputView(type: .phoneNumber)
        if mode == .default {
            view.textField.isEnabled = false
            return view
        } else {
            view.textField.delegate = self
        }
        
        return view
    }()
    
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
            navigationItem.title = "연락처"
        }
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
    
    @objc private func rightBarButtonDidTap() {
        if nameInputView.textField.text!.isEmpty || phoneNumberInputView.textField.text!.isEmpty {
            showAlert()
        } else {
            // TODO: 데이터 추가 로직
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "알림", message: "필수항목을 입력해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        
        present(alert, animated: true)
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
    func fetchRandomImageURL(completion: @escaping (URL?) -> Void) {
        let randomNumber = Int.random(in: 1...1000)
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(randomNumber)") else { return completion(nil) }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  error == nil else { return completion(nil) }
            
            if let response = response as? HTTPURLResponse,
               (200..<300).contains(response.statusCode) {
                guard let decodedData = try? JSONDecoder().decode(RandomImageResponseDTO.self, from: data) else { return completion(nil) }
                
                completion(decodedData.image.url)
                return
            }
        }.resume()
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
