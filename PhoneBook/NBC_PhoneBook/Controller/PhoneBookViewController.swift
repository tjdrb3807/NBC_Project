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
        view.delegate = self
        
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
        view.textField.delegate = self
        
        return view
    }()
    
    private lazy var phoneNumberInputView = {
        let view = CustomTextInputView(type: .phoneNumber)
        view.textField.delegate = self
        
        return view
    }()
    
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
            guard let data = data, error == nil else { return completion(nil) }
            
            if let response = response as? HTTPURLResponse,
               (200..<300).contains(response.statusCode) {
                guard let decodedData = try? JSONDecoder().decode(RandomImageResponseDTO.self, from: data) else { return completion(nil) }
                
                return completion(decodedData.image.url)
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
