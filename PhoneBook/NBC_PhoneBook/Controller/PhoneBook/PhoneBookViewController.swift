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
    case edit
    case `default`
}

final class PhoneBookViewController: BaseViewController {
    var mode: PhoneBookVCMode!
    var model: ContactInfo!
    var cutNextVC: UIViewController?
    
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
        guard let mode = mode else { return view }
        
        switch mode {
        case .add:
            view.delegate = self
        case .edit:
            view.imageView.kf.setImage(with: model.profileImageURL)
            view.delegate = self
        case .default:
            view.imageView.kf.setImage(with: model.profileImageURL)
            view.randomImageFetchButton.isHidden = true
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
        guard let mode = mode else { return view }
        
        switch mode {
        case .add:
            view.textField.delegate = self
            view.delegate = self
        case .edit:
            view.textField.text = model.name
            view.textField.delegate = self
            view.delegate = self
        case .default:
            view.textField.text = model.name
            view.textField.isEnabled = false
        }
        
        return view
    }()
    
    private lazy var phoneNumberInputView = {
        let view = CustomTextInputView(type: .phoneNumber)
        guard let mode = mode else { return view }
        
        switch mode {
        case .add:
            view.textField.delegate = self
            view.delegate = self
        case .edit:
            view.textField.text = model.phoneNumber
            view.delegate = self
        case .default:
            view.textField.text = model.phoneNumber
            view.textField.isEnabled = false
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
                action: #selector(addModeRightBarButtonDidTap))
        case .edit:
            navigationItem.title = "연락처 편집"
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: "취소",
                style: .done,
                target: self,
                action: #selector(editModeLeftBarButtonDidTap))
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "적용",
                style: .done,
                target: self,
                action: #selector(editModeRightBarButtonDidTap))
        case .default:
            navigationItem.title = "\(model.name)"
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "수정",
                style: .done,
                target: self,
                action: #selector(defaultModeRightBarButtonDidTap))
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        view.addSubview(contentStackView)
        
        [profileImageView, inputStackView].forEach { contentStackView.addArrangedSubview($0) }
        
        [nameInputView, phoneNumberInputView].forEach { inputStackView.addArrangedSubview($0) }
        
        // default 상태에서는 이미지 생성 버튼 숨김
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
    /// PhoneBookVCMode == .add 상태의 navigatioBar.rightBarButton 탭했을 떄 호출
    ///
    /// 필수입력란이 공란상태일때 저장버튼을 눌렀을 경우
    ///
    ///     - 알럿
    /// 필수입력한을 채운 후 저장버튼을 눌렀을 경우
    ///
    ///     - 데이터 저장
    ///     - 데이터 변경 내역 MainViewController에 알림
    @objc private func addModeRightBarButtonDidTap() {
        if nameInputView.textField.text!.isEmpty || phoneNumberInputView.textField.text!.isEmpty {
            showAlert(title: "알림", message: "필수사항을 입력해주세요.")
        } else {
            model.addData(model)
            modelDataChange?()
            navigationController?.popViewController(animated: true)
        }
    }
    
    /// PhoneBookVCMode == .edit 상태의 navigatioBar.leftBarButton 탭했을 떄 호출
    ///
    /// 변경내역이 없을 경우 PhoneBookVCMode를 default로 전환
    ///
    /// 변경내역이 있을 경우 알럿으로 사용자에게 확인 플로우 진행
    @objc private func editModeLeftBarButtonDidTap() {
        if model.name == model.beforeName &&
            model.phoneNumber == model.beforePhoneNumber &&
            model.profileImageURL == model.beforeProfileImgaeURL {
            
            presentDefaultPhoneBookVC()
        } else {
            let alert = UIAlertController(
                title: "수정을 취소하시겠습니까?",
                message: """
                          수정을 취소하면 
                          변경내역은 저장되지 않습니다.
                          """,
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            alert.addAction(UIAlertAction(
                title: "확인",
                style: .default,
                handler: { [weak self] _ in
                    guard let self = self else { return }
                    presentDefaultPhoneBookVC()
                }))
            
            present(alert, animated: true)
        }
    }
    
    /// PhoneBookVCMode == .edit 상태의 navigationBar.leftBarButton 탭했을 떄 호출
    ///
    /// 업데이트 로직 실행
    ///
    /// MainViewController에 데이터 변경내역 알림
    ///
    /// popViewController
    @objc private func editModeRightBarButtonDidTap() {
        guard let navigationController = navigationController,
              let mainVC = navigationController.viewControllers.first as? MainViewController else { return }
        
        model.updateData(model)
        // TODO: 리펙토링 필요
        mainVC.model.fetchAllData()
        navigationController.popViewController(animated: true)
    }
    
    /// PhoneBookVCMode == .default 상태의 navigatioBar.RightBarButton 탭했을 때 호출
    ///
    /// 현재 model에 저장된 데이터와 새롭게 저장될 데이터를 비교하기 위해 새로운 model 객체 생성
    ///
    /// 새로운 PhoneBookViewController 객체 생성 후 mode == .edit, model 설정
    ///
    /// 화면을 전환하기위해 pop, push 전환(사용자에게 화면전환을 느낄 수 없도록 animated: false)
    @objc private func defaultModeRightBarButtonDidTap() {
        guard let navigationController = navigationController, let model = model else { return }
        
        let editModeVC = PhoneBookViewController()
        let newModel = model
        newModel.beforeName = model.name
        newModel.beforePhoneNumber = model.phoneNumber
        newModel.beforeProfileImgaeURL = model.profileImageURL
        
        editModeVC.mode = .edit
        editModeVC.model = newModel
        editModeVC.nameInputView.textField.becomeFirstResponder()
        
        navigationController.popViewController(animated: false)
        navigationController.pushViewController(editModeVC, animated: false)
    }
    
    private func presentDefaultPhoneBookVC() {
        guard let navigationController = navigationController,
              let model = model else { return }
        
        let defaultModeVC = PhoneBookViewController()
        let newModel = ContactInfo(
            name: model.beforeName,
            phoneNumber: model.beforeName,
            profileImageURL: model.beforeProfileImgaeURL)
        
        defaultModeVC.mode = .default
        defaultModeVC.model = newModel
        
        navigationController.popViewController(animated: false)
        navigationController.pushViewController(defaultModeVC, animated: false)
    }
}

extension PhoneBookViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === nameInputView.textField { phoneNumberInputView.textField.becomeFirstResponder() }
        
        return true
    }
}

extension PhoneBookViewController: ProfileImageViewDelegate {
    func updateProfileImage() {
//        model.fetchRandomImageURLWithURLSession()
        model.fetchRandomImageURLWithAlamo()
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
            vc.model = ContactInfo()
            
            return UINavigationController(rootViewController: vc)
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    }
}

#endif
