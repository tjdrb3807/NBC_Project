//
//  DisplayLable.swift
//  Calculator01
//
//  Created by 전성규 on 11/21/24.
//

import UIKit

final class DisplayLable: UILabel {
    func update(context: String) {
        text = context
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    
        text = "0"
        textColor = .white
        textAlignment = .right
        font = .boldSystemFont(ofSize: 60.0)
        numberOfLines = 0
        lineBreakMode = .byTruncatingHead
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#if DEBUG

import SwiftUI

struct DisplayLable_Previews: PreviewProvider {
    static var previews: some View {
        DisplayLable_Presentable()
            .frame(
                width: UIScreen.main.bounds.width - 60.0,
                height: 100.0,
                alignment: .center)
    }
    
    struct DisplayLable_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let view = DisplayLable()
            view.text = "12312*2"
            view.backgroundColor = .black
            
            return view
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif

