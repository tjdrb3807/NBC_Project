//
//  ProfileImageView.swift
//  NBC_PhoneBook
//
//  Created by 전성규 on 12/9/24.
//

import UIKit
import SnapKit

final class ProfileImageView: UIStackView {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        
        imageView.layer.cornerRadius = 200.0 / 2
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.systemBackground.cgColor
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var randomImageFetchButton: UIButton = {
        let button = UIButton()
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        
        self.configureUI()
        self.setupConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        axis = .vertical
        alignment = .center
        distribution = .fillProportionally
        spacing = 20.0
        
        [imageView, randomImageFetchButton].forEach { addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { $0.width.height.equalTo(200.0) }
    }
}

#if DEBUG

import SwiftUI

struct ProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImageView_Presentable()
            .frame(
                width: UIScreen.main.bounds.width,
                height: 250.0,
                alignment: .center)
    }
    
    struct ProfileImageView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ProfileImageView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
