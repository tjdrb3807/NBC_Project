//
//  PhoneBookTableViewCell.swift
//  NBC_PhoneBook
//
//  Created by 전성규 on 12/9/24.
//

import UIKit
import SnapKit
import Kingfisher

final class PhoneBookTableViewCell: BaseTableViewCell {
    static let identifier = "PhoneBookTableViewCell"
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        imageView.layer.cornerRadius = 70.0 / 2
        imageView.layer.borderWidth = 1.0
        
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "name"
        label.font = .systemFont(ofSize: 17.0, weight: .regular)
        
        return label
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "010-0000-0000"
        label.font = .systemFont(ofSize: 17.0, weight: .regular)
        
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = nil
        phoneNumberLabel.text = nil
        profileImageView.kf.cancelDownloadTask()
        profileImageView.image = nil            
    }
    
    override func configureUI() {
        super.configureUI()
        
        [profileImageView, nameLabel, phoneNumberLabel].forEach { contentView.addSubview($0) }
    }
    
    override func setupConstraints() {
        profileImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(5.0)
            $0.leading.equalToSuperview().inset(20.0)
            $0.width.equalTo(profileImageView.snp.height)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(20.0)
            $0.centerY.equalTo(profileImageView.snp.centerY)
        }
        
        phoneNumberLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20.0)
            $0.centerY.equalTo(profileImageView.snp.centerY)
        }
    }
    
    func updateUI(name: String, phoneNumber: String, profileImageURL: URL?) {
        self.nameLabel.text = name
        self.phoneNumberLabel.text = phoneNumber
        self.profileImageView.kf.setImage(with: profileImageURL)
    }
}

#if DEBUG

import SwiftUI

struct PhoneBookTableViewCell_Previews: PreviewProvider {
    static var previews: some View {
        PhoneBookTableViewCell_Presentable()
            .frame(
                width: UIScreen.main.bounds.width,
                height: 80.0,
                alignment: .center)
    }
    
    struct PhoneBookTableViewCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            PhoneBookTableViewCell()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
