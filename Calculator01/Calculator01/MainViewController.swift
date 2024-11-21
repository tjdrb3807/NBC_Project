//
//  MainViewController.swift
//  Calculator01
//
//  Created by 전성규 on 11/19/24.
//

import UIKit
import SnapKit

final class MainViewController: BaseViewController {
    private lazy var disPlayLabel: DisplayLable = { DisplayLable() }()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10.0
    
        return stackView
    }()
    
    private func makeHStackView(_ views: [UIView]) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10.0
        
        views.forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        [disPlayLabel, vStackView].forEach { view.addSubview($0) }
    
        [makeHStackView(
            [KeyPadButton(NumberKeyPad.seven),
             KeyPadButton(NumberKeyPad.eight),
             KeyPadButton(NumberKeyPad.nine),
             KeyPadButton(OperatorKeyPad.add)]),
        makeHStackView(
            [KeyPadButton(NumberKeyPad.four),
             KeyPadButton(NumberKeyPad.five),
             KeyPadButton(NumberKeyPad.six),
             KeyPadButton(OperatorKeyPad.sub)]),
        makeHStackView(
            [KeyPadButton(NumberKeyPad.one),
             KeyPadButton(NumberKeyPad.two),
             KeyPadButton(NumberKeyPad.three),
             KeyPadButton(OperatorKeyPad.mul)]),
        makeHStackView(
            [KeyPadButton(OperatorKeyPad.allClear),
             KeyPadButton(NumberKeyPad.zero),
             KeyPadButton(OperatorKeyPad.equal),
             KeyPadButton(OperatorKeyPad.div)])
        ].forEach { vStackView.addArrangedSubview($0) }
    }
    
    override func setupContraints() {
        disPlayLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(200.0)
            $0.leading.trailing.equalToSuperview().inset(30.0)
            $0.height.equalTo(100.0)
        }

        vStackView.snp.makeConstraints {
            $0.top.equalTo(disPlayLabel.snp.bottom).offset(60.0)
            $0.centerX.equalToSuperview()
        }
        
        vStackView.arrangedSubviews.forEach {
            guard let hStackView = $0 as? UIStackView else { return }
            
            hStackView.arrangedSubviews.forEach {
                guard let keyPadButton = $0 as? KeyPadButton else { return }
                
                keyPadButton.snp.makeConstraints { $0.width.height.equalTo(80.0) }
                keyPadButton.addTarget(self, action: #selector(tapKeyPadButton(_:)), for: .touchUpInside)
            }
        }
    }

    @objc private func tapKeyPadButton(_ sender: UIButton) {
        guard let sender = sender as? KeyPadButton else { return }
        
        if sender.type is OperatorKeyPad {
            guard let operatorType = sender.type as? OperatorKeyPad else { return }
            
            if operatorType == .equal {
                disPlayLabel.text = String(calculate(expression: disPlayLabel.text!) ?? 0)
                return
            } else if operatorType == .allClear {
                disPlayLabel.text = NumberKeyPad.zero.rawValue
                return
            }
        } else { if disPlayLabel.text?.count == 1 && disPlayLabel.text == NumberKeyPad.zero.rawValue { disPlayLabel.text = "" } }
        
        disPlayLabel.text?.append(sender.type.text)
    }
    
    private func calculate(expression: String) -> Int? {
            let expression = NSExpression(format: expression)
        if let result = expression.expressionValue(with: nil, context: nil) as? Int {
            return result
        } else {
            return nil
        }
    }
}

#if DEBUG

import SwiftUI

struct MainViewController_Previews: PreviewProvider {
    static var previews: some View {
        MainViewController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct MainViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            MainViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
