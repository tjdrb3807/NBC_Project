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

final class CustomTextInputView: UIStackView {
    var type: InputType
    
    private lazy var titleLabel: UILabel = { [weak self] in
        guard let self = self else { return UILabel() }
        
        let label = UILabel()
        label.text = type.rawValue
        label.font = .systemFont(ofSize: 12.0, weight: .light)
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var textField: UITextField = { [weak self] in
        guard let self = self else { return UITextField() }
        
        let textField = UITextField()
        switch type {
        case .name:
            textField.placeholder = "이름을 입력해주세요."
        case .phoneNumber:
            textField.placeholder = "010-0000-0000"
        }
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 17.0)
        textField.backgroundColor = .clear
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 12.0
        
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
