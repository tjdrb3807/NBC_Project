//
//  CurrentWeahterView.swift
//  Weather
//
//  Created by 전성규 on 12/5/24.
//

import UIKit
import SnapKit

final class CurrentWeahterView: UIStackView {
    private let infoVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 10.0
        
        return stackView
    }()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "서울특별시"
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: 20.0)
        
        return label
    }()
    
    private let crtCelsiusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: 40.0)
        
        return label
    }()
    
    private let celsiusHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 20.0
        
        return stackView
    }()
    
    private let minimumSelsiusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 15.0)
        
        return label
    }()
    
    private let maximumCelsiusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 15.0)
        
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .blue
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.configureUI()
        self.setupConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(currentTemp: Double, minTemp: Double, maxTemp: Double) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.crtCelsiusLabel.text = "\(currentTemp)℃"
            self.minimumSelsiusLabel.text = "최소: \(minTemp)℃"
            self.maximumCelsiusLabel.text = "최고: \(maxTemp)℃"
        }
    }
    
    private func configureUI() {
        axis = .vertical
        alignment = .center
        distribution = .equalSpacing
        spacing = 30.0
        
        [infoVStackView, weatherImageView].forEach { addArrangedSubview($0) }
        
        [cityLabel, crtCelsiusLabel, celsiusHStackView].forEach { infoVStackView.addArrangedSubview($0) }
        
        [minimumSelsiusLabel, maximumCelsiusLabel].forEach { celsiusHStackView.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        weatherImageView.snp.makeConstraints { $0.width.height.equalTo(180.0) }
    }
}

#if DEBUG

import SwiftUI

struct CurrentWeahterView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeahterView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(
                width: UIScreen.main.bounds.width,
                height: UIScreen.main.bounds.height / 2,
                alignment: .center)
    }
    
    struct CurrentWeahterView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let view = CurrentWeahterView()
            view.backgroundColor = .black
            view.updateUI(currentTemp: 20.0, minTemp: 16.0, maxTemp: 21.0)
            
            return view
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) { }
    }
}

#endif
