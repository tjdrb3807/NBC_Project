//
//  CustomTextInputView.swift
//  NBC_PhoneBook
//
//  Created by 전성규 on 12/9/24.
//

import UIKit
import SnapKit

enum InputType: String {
    case name = "이름"
    case phoneNumber = "휴대폰번호"
}

protocol CustomTextInputViewDelegate: AnyObject {
    func updateTextData(_ textField: UITextField, value: String)
}

final class CustomTextInputView: UIStackView {
    weak var delegate: CustomTextInputViewDelegate?
    var type: InputType
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        let text = "\(type.rawValue) (필수)"
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: "(필수)")
        
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
        label.attributedText = attributedString
        label.font = .systemFont(ofSize: 12.0, weight: .light)
        label.numberOfLines = 1

        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        switch type {
        case .name:
            textField.placeholder = "홍길동"
        case .phoneNumber:
            textField.placeholder = "010-0000-0000"
            textField.keyboardType = .numberPad
        }
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 17.0)
        textField.backgroundColor = .clear
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 12.0
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        
        let spacing = UIView(frame: .init(x: 0.0, y: 0.0, width: 10.0, height: textField.frame.height))
        textField.leftView = spacing
        textField.leftViewMode = .always
        
        textField.addTarget(
            self,
            action: #selector(textFieldEditingChanged),
            for: .editingChanged)
        
        return textField
    }()
    
    init(type: InputType) {
        self.type = type
        super.init(frame: .zero)
        
        self.configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        axis = .vertical
        alignment = .fill
        distribution = .fillProportionally
        spacing = 5.0
        
        [titleLabel, textField].forEach { addArrangedSubview($0) }
    }
    
    @objc private func textFieldEditingChanged() {
        delegate?.updateTextData(self.textField, value: textField.text!)
    }
}

#if DEBUG

import SwiftUI

struct CustomTextInputView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextInputView_Presentable()
            .frame(
                width: UIScreen.main.bounds.width - 40.0,
                height: 70.0,
                alignment: .center)
    }
    
    struct CustomTextInputView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            CustomTextInputView(type: .name)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
