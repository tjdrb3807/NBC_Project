//
//  ProfileImageView.swift
//  NBC_PhoneBook
//
//  Created by 전성규 on 12/9/24.
//

import UIKit
import SnapKit
import Kingfisher

protocol ProfileImageViewDelegate: AnyObject {
    func updateProfileImage()
}

final class ProfileImageView: UIStackView {
    weak var delegate: ProfileImageViewDelegate?
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.layer.cornerRadius = 180.0 / 2
        imageView.layer.borderWidth = 1.0
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy var randomImageFetchButton: UIButton = {
        let button = UIButton()
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        button.addTarget(
            self,
            action: #selector(randomInageFetchButtonDidTap),
            for: .touchUpInside)
        
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
    
    func updateProfileImage(with url: URL) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            imageView.kf.setImage(with: url)
        }
    }
    
    private func configureUI() {
        axis = .vertical
        alignment = .center
        distribution = .fill
        spacing = 10.0
        
        [imageView, randomImageFetchButton].forEach { addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { $0.width.height.equalTo(180.0) }
    }
    
    @objc private func randomInageFetchButtonDidTap() {
        delegate?.updateProfileImage()
    }
}

#if DEBUG

import SwiftUI

struct ProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImageView_Presentable()
            .frame(
                width: UIScreen.main.bounds.width,
                height: 210.0,
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
