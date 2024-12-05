//
//  PastWeatherTableViewCell.swift
//  Weather
//
//  Created by 전성규 on 12/5/24.
//

import UIKit
import SnapKit

final class PastWeatherTableViewCell: UITableViewCell {
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20.0)
        
        return label
    }()
    
    private lazy var celsiusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20.0)
        
        return label
    }()
    
    static let identifier = "PastWeatherTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configureUI()
        self.setupConstraints()
    }
    
    func setupData(_ data: String, _ celsius: Double) {
        self.dateLabel.text = data
        self.celsiusLabel.text = "\(celsius)℃"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(
                top: 0.0,
                left: 20.0,
                bottom: 10.0,
                right: 20.0))
    }
    
    private func configureUI() {
        isUserInteractionEnabled = false
        
        [dateLabel, celsiusLabel].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        dateLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(20.0)
        }
        
        celsiusLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20.0)
        }
    }
}

#if DEBUG

import SwiftUI

struct PastWeatherTableViewCell_Presentable: PreviewProvider {
    static var previews: some View {
        PastWeatherTableViewCell_Presentable()
            .frame(
                width: UIScreen.main.bounds.width,
                height: 50.0,
                alignment: .center)
    }
    
    struct PastWeatherTableViewCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = PastWeatherTableViewCell()
            v.backgroundColor = .black
            v.setupData("2024-12-05 18:00:00", 22.08)
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
