//
//  KeyPadButton.swift
//  Calculator01
//
//  Created by 전성규 on 11/19/24.
//

import UIKit

// 한 개의 매개변수에 두가지 Value Type을 전달하기 위해 인터페이스 구현
// 전달하려는 매개변수 타입을 해당 프로토콜로 선언해 프로토콜을 채택한 Type을 매개변수로 전달할 수 있도록 구현
protocol KeyPad {
    var text: String { get }
}

enum NumberKeyPad: String, KeyPad {
    var text: String {
        get { rawValue }
    }
    
    case zero = "0"
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
}

enum OperatorKeyPad: String, KeyPad {
    var text: String {
        get { rawValue }
    }
    
    case add = "+"
    case sub = "-"
    case mul = "*"
    case div = "/"
    case equal = "="
    case allClear = "AC"
}

final class KeyPadButton: UIButton {
    let type: KeyPad
    
    init(_ type: any KeyPad) {
        self.type = type
        super.init(frame: .zero)
        
        self.setupProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupProperties() {
        setTitle(type.text, for: .normal)
        titleLabel?.textColor = .white
        titleLabel?.font = .boldSystemFont(ofSize: 30.0)
        layer.cornerRadius = 80.0 / 2
        
        // 이니셜라이저의 매개변수를 통해 전달받은 데이터(type)에 따른 button properties 설정
        type is NumberKeyPad ?
        (backgroundColor = UIColor(red: 58/255, green: 58/255, blue: 58/255, alpha: 1.0)) :
        (backgroundColor = .orange)
    }
}

#if DEBUG

import SwiftUI

struct KeyPadButton_Previews: PreviewProvider {
    static var previews: some View {
        KeyPadButton_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(
                width: 80.0,
                height: 80.0,
                alignment: .center)
    }
    
    struct KeyPadButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView { KeyPadButton(NumberKeyPad.one) }
        
        func updateUIView(_ uiView: UIViewType, context: Context) { }
    }
}

#endif
